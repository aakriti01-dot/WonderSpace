
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const WonderSpaceApp());
}

class WonderSpaceApp extends StatelessWidget {
  const WonderSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WonderSpace',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFA94D),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

