
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome,
              size: 75,
              color: Color(0xFFFFA94D),
            ),
            const SizedBox(height: 20),
            const Text(
              'WonderSpace',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF45405A),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'A little wonder in every moment.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF777080),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
