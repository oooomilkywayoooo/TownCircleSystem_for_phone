-- ローカル開発用の初期データ。
-- 会員・管理者とも共通パスワードは password123（ローカル開発専用、本番では絶対に使わないこと）。

SET NAMES utf8mb4;

INSERT INTO admins (login_id, password_hash, name) VALUES
('admin', '$2y$12$PzYxRr.X3LUplz6jY8qSCuKEOLQwhOL1QXbaGNVplX/FINKaqVu/e', '管理者');

INSERT INTO member_groups (name, sort_order, is_active) VALUES
('1組', 1, 1),
('2組', 2, 1),
('3組', 3, 1);

INSERT INTO members (name, address, phone, email, password_hash, family_count, group_id, role) VALUES
('佐藤 太郎', '○○県○○市1-2-3', '090-1111-2222', 'taro.sato@example.com', '$2y$12$PzYxRr.X3LUplz6jY8qSCuKEOLQwhOL1QXbaGNVplX/FINKaqVu/e', 3, (SELECT id FROM member_groups WHERE name = '1組'), 'leader'),
('高橋 次郎', '○○県○○市3-1-9', '090-5555-6666', 'jiro.takahashi@example.com', '$2y$12$PzYxRr.X3LUplz6jY8qSCuKEOLQwhOL1QXbaGNVplX/FINKaqVu/e', 2, (SELECT id FROM member_groups WHERE name = '1組'), 'vice_leader'),
('鈴木 花子', '○○県○○市2-4-6', '090-3333-4444', 'hanako.suzuki@example.com', '$2y$12$PzYxRr.X3LUplz6jY8qSCuKEOLQwhOL1QXbaGNVplX/FINKaqVu/e', 4, (SELECT id FROM member_groups WHERE name = '2組'), 'none'),
('田中 一郎', '○○県○○市2-1-1', '090-7777-8888', 'ichiro.tanaka@example.com', '$2y$12$PzYxRr.X3LUplz6jY8qSCuKEOLQwhOL1QXbaGNVplX/FINKaqVu/e', 2, (SELECT id FROM member_groups WHERE name = '2組'), 'leader'),
('伊藤 光', '○○県○○市3-5-2', '090-9999-0000', 'hikaru.ito@example.com', '$2y$12$PzYxRr.X3LUplz6jY8qSCuKEOLQwhOL1QXbaGNVplX/FINKaqVu/e', 1, (SELECT id FROM member_groups WHERE name = '3組'), 'leader');

INSERT INTO notices (title, body, published_at) VALUES
('夏祭りのお知らせ', '日時：2026年8月1日（土）17:00〜20:00\n場所：町内公園\n出店や盆踊りを予定しています。ぜひご参加ください。', '2026-07-01'),
('防災訓練について', '日時：2026年7月20日（月）9:00〜\n場所：町内公園\n避難訓練と消火器の使い方講習を行います。', '2026-06-15'),
('ゴミ収集日変更のお知らせ', '祝日にあたるため、収集日が1日順延となります。詳しくは市の案内をご確認ください。', '2026-05-20');

INSERT INTO circulars (title, start_date, end_date) VALUES
('自治会費集金のお知らせ', '2026-07-01', '2026-07-31'),
('資源ごみ回収カレンダー', '2026-06-01', '2026-06-30'),
('防犯パトロールのお知らせ', '2026-05-01', '2026-05-31');

INSERT INTO circular_reads (circular_id, member_id) VALUES
((SELECT id FROM circulars WHERE title = '資源ごみ回収カレンダー'), (SELECT id FROM members WHERE email = 'hanako.suzuki@example.com')),
((SELECT id FROM circulars WHERE title = '防犯パトロールのお知らせ'), (SELECT id FROM members WHERE email = 'hanako.suzuki@example.com'));

INSERT INTO schedules (date, title, detail) VALUES
('2026-09-06', '資源ごみ回収', NULL),
('2026-09-15', '敬老会', NULL),
('2026-09-27', '町内清掃活動', '朝8時集合'),
('2026-08-01', '夏祭り', NULL),
('2026-08-10', '資源ごみ回収', NULL),
('2026-07-05', '資源ごみ回収', NULL),
('2026-07-20', '夏祭り実行委員会', NULL);

INSERT INTO garbage_duties (month, member_id) VALUES
('2026-07-01', (SELECT id FROM members WHERE email = 'jiro.takahashi@example.com')),
('2026-08-01', (SELECT id FROM members WHERE email = 'taro.sato@example.com')),
('2026-09-01', (SELECT id FROM members WHERE email = 'hanako.suzuki@example.com')),
('2026-10-01', (SELECT id FROM members WHERE email = 'jiro.takahashi@example.com')),
('2026-11-01', (SELECT id FROM members WHERE email = 'taro.sato@example.com'));

INSERT INTO chat_messages (room_type, member_id, sender_member_id, sender_is_admin, body, created_at) VALUES
('all', NULL, NULL, 1, '来週の町内清掃活動は9/27（日）朝8時からです。', '2026-09-20 10:02:00'),
('all', NULL, (SELECT id FROM members WHERE email = 'hanako.suzuki@example.com'), 0, '承知しました、参加します。', '2026-09-20 10:15:00'),
('all', NULL, (SELECT id FROM members WHERE email = 'taro.sato@example.com'), 0, '軍手を持参いただけると助かります。', '2026-09-20 10:20:00'),
('leader_dm', (SELECT id FROM members WHERE email = 'jiro.takahashi@example.com'), (SELECT id FROM members WHERE email = 'jiro.takahashi@example.com'), 0, '来月の資源ごみ回収、当番表の確認をお願いします。', '2026-09-21 14:10:00');

INSERT INTO surveys (title, google_form_url, published_at) VALUES
('夏祭りに関するアンケート', 'https://forms.gle/example1', '2026-06-10'),
('町内会運営に関するご意見募集', 'https://forms.gle/example2', '2026-05-01');

INSERT INTO documents (name, file_path, file_size_bytes, uploaded_at) VALUES
('町内会規約.pdf', '/files/kiyaku.pdf', 1258291, '2026-04-01'),
('防災マニュアル.pdf', '/files/bousai.pdf', 3565158, '2026-05-10'),
('総会議事録.pdf', '/files/sokai.pdf', 870400, '2026-06-01');

INSERT INTO opinions (body, is_anonymous, member_id) VALUES
('夜間のゴミ出しをやめてほしいです。', 1, NULL),
('掲示板の場所を増やしてほしいです。', 0, (SELECT id FROM members WHERE email = 'hanako.suzuki@example.com'));
