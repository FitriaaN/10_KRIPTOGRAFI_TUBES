import 'package:flutter/material.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import '../widgets/loading_overlay.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'Nama Pengguna');
  final _phoneController = TextEditingController(text: '08123456789');
  bool _isLoading = false;

  void _save() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Profil')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AppTextField(
                label: 'Nama',
                controller: _nameController,
                hintText: 'Masukkan nama',
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'No. HP',
                controller: _phoneController,
                hintText: 'Masukkan nomor HP',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Simpan',
                onPressed: _save,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}