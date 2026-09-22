import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TownCircleApp());
}

class TownCircleApp extends StatelessWidget {
  const TownCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '町内会システム',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
