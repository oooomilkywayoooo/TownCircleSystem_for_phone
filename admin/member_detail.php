<?php
$pageTitle = '会員詳細';
require __DIR__ . '/includes/header.php';

$members = [
    1 => [
        'name' => '佐藤 太郎',
        'address' => '○○県○○市1-2-3',
        'phone' => '090-1111-2222',
        'email' => 'taro.sato@example.com',
        'family' => 3,
        'group' => '1組',
        'role' => '組長',
    ],
    2 => [
        'name' => '鈴木 花子',
        'address' => '○○県○○市2-4-6',
        'phone' => '090-3333-4444',
        'email' => 'hanako.suzuki@example.com',
        'family' => 4,
        'group' => '2組',
        'role' => '役職なし',
    ],
    3 => [
        'name' => '高橋 次郎',
        'address' => '○○県○○市3-1-9',
        'phone' => '090-5555-6666',
        'email' => 'jiro.takahashi@example.com',
        'family' => 2,
        'group' => '1組',
        'role' => '副組長',
    ],
];

$id = isset($_GET['id']) ? (int) $_GET['id'] : 1;
$member = $members[$id] ?? $members[1];

$groups = ['1組', '2組', '3組'];
$roles = ['役職なし', '組長', '副組長'];
?>

<div class="bg-white p-4 rounded shadow-sm mb-4" style="max-width:640px;">
  <dl class="row mb-0">
    <dt class="col-sm-3">氏名</dt><dd class="col-sm-9"><?php echo htmlspecialchars($member['name']); ?></dd>
    <dt class="col-sm-3">住所</dt><dd class="col-sm-9"><?php echo htmlspecialchars($member['address']); ?></dd>
    <dt class="col-sm-3">電話番号</dt><dd class="col-sm-9"><?php echo htmlspecialchars($member['phone']); ?></dd>
    <dt class="col-sm-3">メールアドレス</dt><dd class="col-sm-9"><?php echo htmlspecialchars($member['email']); ?></dd>
    <dt class="col-sm-3">家族人数</dt><dd class="col-sm-9"><?php echo $member['family']; ?>人</dd>
    <dt class="col-sm-3">グループ</dt><dd class="col-sm-9"><?php echo htmlspecialchars($member['group']); ?></dd>
    <dt class="col-sm-3">役職</dt>
    <dd class="col-sm-9">
      <?php if ($member['role'] !== '役職なし'): ?>
        <span class="badge bg-primary"><?php echo htmlspecialchars($member['role']); ?></span>
      <?php else: ?>
        <span class="text-muted">役職なし</span>
      <?php endif; ?>
    </dd>
  </dl>
</div>

<form action="member_list.php" method="post" class="bg-white p-4 rounded shadow-sm mb-4" style="max-width:480px;">
  <div class="mb-3">
    <label class="form-label">グループ変更</label>
    <select class="form-select" name="group">
      <?php foreach ($groups as $g): ?>
        <option <?php echo $g === $member['group'] ? 'selected' : ''; ?>><?php echo htmlspecialchars($g); ?></option>
      <?php endforeach; ?>
    </select>
  </div>
  <div class="mb-3">
    <label class="form-label">役職</label>
    <select class="form-select" name="role">
      <?php foreach ($roles as $r): ?>
        <option <?php echo $r === $member['role'] ? 'selected' : ''; ?>><?php echo htmlspecialchars($r); ?></option>
      <?php endforeach; ?>
    </select>
    <div class="form-text">同じ組で「組長」「副組長」に設定できるのはそれぞれ1名までを想定しています。</div>
  </div>
  <button type="submit" class="btn btn-primary">変更</button>
</form>

<div class="d-flex gap-2">
  <a href="mailto:<?php echo htmlspecialchars($member['email']); ?>" class="btn btn-outline-primary">連絡する</a>
  <button class="btn btn-outline-danger" type="button">この会員を削除</button>
  <a href="member_list.php" class="btn btn-outline-secondary">一覧へ戻る</a>
</div>

<?php require __DIR__ . '/includes/footer.php'; ?>
