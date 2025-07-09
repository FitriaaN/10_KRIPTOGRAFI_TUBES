// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    const userName = 'Nama Pengguna';
    const userEmail = 'user@email.com';
    const userPhone = '08123456789';

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Pengguna',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Nama: $userName'),
            const SizedBox(height: 8),
            Text('Email: $userEmail'),
            const SizedBox(height: 8),
            Text('Nomor HP: $userPhone'),
          ],
        ),
      ),
    );
  }
}
