import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Dio get _dio => ref.read(dioProvider);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter email and password.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;
      if (token == null) {
        _showMessage('Login failed: invalid response from server.');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('student_token', token);
      await prefs.setString('student_name', data['name'] as String? ?? '');
      await prefs.setString('student_email', data['email'] as String? ?? '');
      await prefs.setString('student_mobile', data['mobileNumber'] as String? ?? '');

      context.go('/');
    } on DioException catch (error) {
      final message = error.response?.data is Map<String, dynamic>
          ? (error.response?.data['message']?.toString() ?? error.message)
          : error.message;
      _showMessage('Login failed: $message');
    } catch (error) {
      _showMessage('Login failed: ${error.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Continue your preparation', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            TextField(controller: emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: isLoading ? null : _login,
              child: isLoading ? const CircularProgressIndicator.adaptive() : const Text('Login'),
            ),
            TextButton(onPressed: () => context.go('/register'), child: const Text('Create an account')),
            TextButton(onPressed: () {}, child: const Text('Forgot password'))
          ],
        ),
      ),
    );
  }
}
