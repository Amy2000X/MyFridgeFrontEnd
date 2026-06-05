import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const storage = FlutterSecureStorage();
  static const String baseUrl = 'https://myfridgebackend-xsow.onrender.com';

  static String? access_token;

  static Future<void> saveToken (String token) async {
    access_token = token;

    await storage.write(
      key: 'auth_token', value: token
      );
  }

  static Future<void> loadToken() async {
    access_token = await storage.read(key: 'auth_token');
  }

  static Future<void> deleteToken() async {
    await storage.delete(key: 'auth_token');
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    print("LOGIN URL: $baseUrl/auth/login");
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(
    String email,
    String password,
  ) async {
    print("REGISTER URL: $baseUrl/auth/register");
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }
}