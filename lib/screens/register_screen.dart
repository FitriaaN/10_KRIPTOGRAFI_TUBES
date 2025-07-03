// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import '../widgets/loading_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/des_helper.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  // Menghapus _role karena tidak lagi digunakan dalam AuthService yang dimodifikasi
  // String _role = 'buyer'; 

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi loading UI
    // Enkripsi semua field
    final encryptedName = CustomEncryption.encrypt(_nameController.text.trim());
    final encryptedEmail = CustomEncryption.encrypt(_emailController.text.trim());
    final encryptedPassword = CustomEncryption.encrypt(_passwordController.text.trim());
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': encryptedName,
        'email': encryptedEmail,
        'password': encryptedPassword,
      });
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil!')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan ke database: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Nama',
                  controller: _nameController,
                  hintText: 'Masukkan nama',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Masukkan nama';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                    if (value.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                // Menghapus DropdownButtonFormField untuk role
                // DropdownButtonFormField<String>(
                //   value: _role,
                //   items: const [
                //     DropdownMenuItem(value: 'buyer', child: Text('Buyer')),
                //     DropdownMenuItem(value: 'seller', child: Text('Seller')),
                //   ],
                //   onChanged: (value) {
                //     if (value != null) setState(() => _role = value);
                //   },
                // ),
                const SizedBox(height: 20),
                AppButton(
                  text: 'Daftar',
                  onPressed: _register,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}