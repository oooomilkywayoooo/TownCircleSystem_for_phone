-- TownCircleSystem 町内会管理システム
-- データベーススキーマ（MySQL 8.0 / InnoDB / utf8mb4想定）
--
-- 設計方針:
--  - 組長・副組長は member_groups テーブルに持たせず、members.role + members.group_id から導出する
--    （役職は「今この人が何の役職か」という会員側の属性であり、異動・退会時に二重管理を避けるため）
--  - チャットは chat_rooms を作らず、chat_messages.room_type / member_id だけで表現する
--    （「町内会全体」は単一ルーム、「組長とのチャット」は member_id ごとに1本のスレッドとして扱える）
--  - ご意見箱の匿名投稿は member_id を保存しないことで、DB上でも本当に匿名にする
--  - 会員のログインはモバイルアプリ想定のためトークン認証（member_auth_tokens）、
--    管理者はブラウザのためPHPセッションで代用しDB上のテーブルは持たない

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 管理者
-- ============================================================
CREATE TABLE admins (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    login_id        VARCHAR(50)     NOT NULL,
    password_hash   VARCHAR(255)    NOT NULL,
    name            VARCHAR(100)    NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_admins_login_id (login_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- グループ（組）
-- ============================================================
CREATE TABLE member_groups (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(50)     NOT NULL COMMENT '例: 1組, 2組, 3組',
    sort_order      INT             NOT NULL DEFAULT 0,
    is_active       TINYINT(1)      NOT NULL DEFAULT 1 COMMENT 'グループ管理のフラグ管理に対応',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_member_groups_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 会員（一般会員）
-- ============================================================
CREATE TABLE members (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100)    NOT NULL,
    address         VARCHAR(255)    NOT NULL,
    phone           VARCHAR(20)     NOT NULL,
    email           VARCHAR(255)    NOT NULL,
    password_hash   VARCHAR(255)    NOT NULL,
    family_count    INT UNSIGNED    NOT NULL DEFAULT 1,
    group_id        BIGINT UNSIGNED NULL,
    role            ENUM('none','leader','vice_leader') NOT NULL DEFAULT 'none'
                        COMMENT 'none=役職なし, leader=組長, vice_leader=副組長',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_members_email (email),
    KEY idx_members_group_id (group_id),
    CONSTRAINT fk_members_group
        FOREIGN KEY (group_id) REFERENCES member_groups(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 会員アプリ用のログイントークン（モバイルはセッションCookieを使わないため）
CREATE TABLE member_auth_tokens (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    member_id       BIGINT UNSIGNED NOT NULL,
    token           CHAR(64)        NOT NULL COMMENT 'ランダム文字列をハッシュ化して保存',
    expires_at      DATETIME        NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_member_auth_tokens_token (token),
    KEY idx_member_auth_tokens_member_id (member_id),
    CONSTRAINT fk_member_auth_tokens_member
        FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 会員のパスワードリセット
CREATE TABLE member_password_resets (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    member_id       BIGINT UNSIGNED NOT NULL,
    token           CHAR(64)        NOT NULL,
    expires_at      DATETIME        NOT NULL,
    used_at         DATETIME        NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_member_password_resets_token (token),
    KEY idx_member_password_resets_member_id (member_id),
    CONSTRAINT fk_member_password_resets_member
        FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- お知らせ
-- ============================================================
CREATE TABLE notices (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(200)    NOT NULL,
    body            TEXT            NOT NULL,
    published_at    DATE            NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_notices_published_at (published_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 回覧板
-- ============================================================
CREATE TABLE circulars (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(200)    NOT NULL,
    body            TEXT            NULL,
    image_path      VARCHAR(255)    NULL,
    start_date      DATE            NOT NULL,
    end_date        DATE            NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_circulars_period (start_date, end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 回覧板の既読管理（行が存在する = 既読）
CREATE TABLE circular_reads (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    circular_id     BIGINT UNSIGNED NOT NULL,
    member_id       BIGINT UNSIGNED NOT NULL,
    read_at         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_circular_reads_pair (circular_id, member_id),
    KEY idx_circular_reads_member_id (member_id),
    CONSTRAINT fk_circular_reads_circular
        FOREIGN KEY (circular_id) REFERENCES circulars(id) ON DELETE CASCADE,
    CONSTRAINT fk_circular_reads_member
        FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- スケジュール
-- ============================================================
CREATE TABLE schedules (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    date            DATE            NOT NULL,
    title           VARCHAR(200)    NOT NULL,
    detail          TEXT            NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_schedules_date (date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- チャット
-- room_type='all'        : 町内会全体チャット（member_idはNULL、単一ルーム）
-- room_type='leader_dm'  : member_id の会員 と その所属組の組長 との個別チャット
--                          （どちらが送ったかは sender_member_id / sender_is_admin で判別）
-- ============================================================
CREATE TABLE chat_messages (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_type           ENUM('all','leader_dm') NOT NULL,
    member_id           BIGINT UNSIGNED NULL COMMENT 'leader_dmのスレッドを識別する相手会員。allの場合はNULL',
    sender_member_id     BIGINT UNSIGNED NULL COMMENT '送信者が会員の場合。退会済みなどでNULLの場合あり',
    sender_is_admin     TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '管理者(事務局)からの投稿か',
    body                TEXT            NOT NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_chat_messages_thread (room_type, member_id, created_at),
    CONSTRAINT fk_chat_messages_member
        FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_messages_sender
        FOREIGN KEY (sender_member_id) REFERENCES members(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- ゴミ当番（会員個人単位で割り当て）
-- ============================================================
CREATE TABLE garbage_duties (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    month           DATE            NOT NULL COMMENT '対象月の1日 (例: 2026-09-01)',
    member_id       BIGINT UNSIGNED NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_garbage_duties_month (month),
    KEY idx_garbage_duties_member_id (member_id),
    CONSTRAINT fk_garbage_duties_member
        FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- アンケート（Googleフォームへのリンク管理）
-- ============================================================
CREATE TABLE surveys (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(200)    NOT NULL,
    google_form_url VARCHAR(500)    NOT NULL,
    published_at    DATE            NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 関連資料
-- ============================================================
CREATE TABLE documents (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(200)    NOT NULL,
    file_path       VARCHAR(255)    NOT NULL,
    file_size_bytes BIGINT UNSIGNED NOT NULL DEFAULT 0,
    uploaded_at     DATE            NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- ご意見箱（匿名投稿時は member_id を保存しない = DB上でも匿名）
-- ============================================================
CREATE TABLE opinions (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    body            TEXT            NOT NULL,
    is_anonymous    TINYINT(1)      NOT NULL DEFAULT 0,
    member_id       BIGINT UNSIGNED NULL COMMENT '匿名投稿の場合は必ずNULL',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_opinions_created_at (created_at),
    CONSTRAINT fk_opinions_member
        FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
