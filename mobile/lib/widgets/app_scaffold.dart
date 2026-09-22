import 'package:flutter/material.dart';
import 'app_drawer.dart';

/// 全画面共通のヘッダー（ハンバーガーメニュー）とドロワーを提供するラッパー。
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      drawer: AppDrawer(currentLabel: title),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
