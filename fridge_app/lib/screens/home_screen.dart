import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';
import 'main_navigation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final token = AuthService.accessToken;

    if (token == null || token.isEmpty) {
      return const LoginScreen();
    }

    return const MainNavigationScreen();
  }
}