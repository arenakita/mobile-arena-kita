import 'package:arena_kita/screens/auth/login_screen.dart';
import 'package:arena_kita/services/auth_service.dart';
import 'package:arena_kita/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ArenaKitaApp());
}

class ArenaKitaApp extends StatelessWidget {
  const ArenaKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArenaKita Owner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: FutureBuilder(
          future: AuthService().isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ArenaKita',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 80),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasData && snapshot.data == true) {
              return const MainScreen();
            }

            return const LoginScreen();
          }),
    );
  }
}
