import 'package:arena_kita/screens/auth/login_screen.dart';
import 'package:arena_kita/services/auth_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await AuthService().logout();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ), (route) => false,
                );
              }
            },
            child: const Text('Logout'))
      ),
    );
  }
}
