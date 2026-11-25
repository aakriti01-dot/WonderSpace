import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEE3D2),
      body: const SafeArea(
        child: SizedBox.expand(),
      ),
    );
  }
}
