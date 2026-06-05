import 'package:flutter/material.dart';
import '../services/auth_service.dart';
// import '../services/fridge_service.dart';
import 'register_screen.dart';
import 'fridge_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String message = '';

  Future<void> login() async {
  print("LOGIN BUTTON PRESSED");

  try {
    final response = await AuthService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (response["access_token"] != null) {
      print("LOGIN SUCCESS");

      await AuthService.saveToken(
        response["access_token"],
        );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FridgeScreen(),
        ),
      );
    } else {
      setState(() {
        message = response["detail"] ?? "Login failed";
      });
    }
  } catch (e) {
    print("LOGIN ERROR:");
    print(e);

    setState(() {
      message = e.toString();
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            Text(message),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text('Go to Register'),
            )
          ],
        ),
      ),
    );
  }
}