import 'package:flutter/material.dart';
import '../models/member_group.dart';
import '../theme/app_theme.dart';

/// 「1組」「2組」…を大きなボタンで選ばせる、組選択専用ウィジェット。
/// プルダウンより一目で選べるため、年齢を問わず操作しやすい。
class GroupSelector extends StatelessWidget {
  final List<MemberGroup> groups;
  final int? selectedId;
  final ValueChanged<int> onChanged;

  const GroupSelector({
    super.key,
    required this.groups,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final group in groups)
          _GroupButton(
            label: group.name,
            selected: group.id == selectedId,
            onTap: () => onChanged(group.id),
          ),
      ],
    );
  }
}

class _GroupButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _GroupButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 92,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppTheme.primary : const Color(0xFFB0BAC5), width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
