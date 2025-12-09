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
      // Nanti diganti ke halaman Login saat fiturnya dibuat
      home: const Scaffold(
        body: Center(child: Text("ArenaKita Initial Setup Ready!")),
      ),
    );
  }
}