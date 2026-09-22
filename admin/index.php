<?php
$pageTitle = 'ホーム';
require __DIR__ . '/includes/header.php';

$menus = [
    ['お知らせ管理', 'notice_list.php'],
    ['回覧板管理', 'circular_list.php'],
    ['グループ管理', 'group_list.php'],
    ['会員管理', 'member_list.php'],
    ['スケジュール管理', 'schedule_list.php'],
    ['チャット管理', 'chat_list.php'],
    ['ゴミ当番管理', 'duty_list.php'],
    ['アンケート管理', 'survey_list.php'],
    ['資料管理', 'document_list.php'],
    ['ご意見管理', 'opinion_list.php'],
];
?>

<div class="row g-3">
  <?php foreach ($menus as $m): ?>
    <div class="col-md-4 col-sm-6">
      <a href="<?php echo htmlspecialchars($m[1]); ?>" class="text-decoration-none">
        <div class="card h-100 shadow-sm">
          <div class="card-body">
            <h5 class="card-title text-dark mb-0"><?php echo htmlspecialchars($m[0]); ?></h5>
          </div>
        </div>
      </a>
    </div>
  <?php endforeach; ?>
</div>

<?php require __DIR__ . '/includes/footer.php'; ?>
