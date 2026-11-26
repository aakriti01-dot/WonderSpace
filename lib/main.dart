
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFAF7F2),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const WonderSpaceApp());
}

class WonderSpaceApp extends StatelessWidget {
  const WonderSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WonderSpace',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF7F2),
        textTheme: GoogleFonts.fredokaTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5D8A85),
          surface: const Color(0xFFFAF7F2),
        ),
      ),

      home: const SplashScreen(
        nextScreen: LoginScreen(),
      ),
    );
  }
}

class WonderSpaceLogo extends StatelessWidget {
  final double fontSize;

  const WonderSpaceLogo({
    super.key,
    this.fontSize = 30,
  });

  static const List<Color> letterColours = [
    Color(0xFF5D8A85),
    Color(0xFFD9AE54),
    Color(0xFFBA6D4D),
    Color(0xFFD47B6A),
    Color(0xFF8EA88E),
    Color(0xFFA89CC4),
    Color(0xFF7FA390),
    Color(0xFF5E8894),
    Color(0xFF8FB1C7),
    Color(0xFFA79BC2),
    Color(0xFF9AB0C4),
  ];

  @override
  Widget build(BuildContext context) {
    const letters = 'WonderSpace';

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        text: TextSpan(
          children: List.generate(
            letters.length,
                (index) => TextSpan(
              text: letters[index],
              style: GoogleFonts.fredoka(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: letterColours[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
