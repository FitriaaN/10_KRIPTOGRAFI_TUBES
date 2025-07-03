// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import '../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login sukses!')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  hintText: 'Masukkan email',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Masukkan email';
                    if (!value.contains('@')) return 'Email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  hintText: 'Masukkan password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Masukkan password';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppButton(
                  text: 'Login',
                  onPressed: _login,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: 'Belum punya akun? Daftar di sini.',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    );
                  },
                  type: ButtonType.text,
                  isFullWidth: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}