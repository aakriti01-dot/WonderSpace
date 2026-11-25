import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({
    super.key,
    required this.nextScreen,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  Timer? _timer;

  static const Color background = Color(0xFFFAF7F2);

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

  static const String letters = 'WonderSpace';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();

    _timer = Timer(const Duration(milliseconds: 7000), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => widget.nextScreen,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLogo() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          children: List.generate(
            letters.length,
                (index) => TextSpan(
              text: letters[index],
              style: GoogleFonts.fredoka(
                fontSize: 57,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
                color: letterColours[index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _star(Color color, double size) {
    return Icon(
      Icons.auto_awesome_rounded,
      color: color,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _star(
                          const Color(0xFFD9AE54),
                          21,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'A WORLD OF LITTLE WONDERS',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              fontSize: 11,
                              letterSpacing: 2,
                              color: const Color(0xFF8EA88E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _star(
                          const Color(0xFFD47B6A),
                          19,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: _buildLogo(),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'A little space for big imaginations.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        color: const Color(0xFF8B8177),
                      ),
                    ),

                    const SizedBox(height: 35),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _star(
                          const Color(0xFFD47B6A),
                          19,
                        ),
                        const SizedBox(width: 22),
                        const Icon(
                          Icons.cloud_outlined,
                          color: Color(0xFF8FB1C7),
                          size: 30,
                        ),
                        const SizedBox(width: 22),
                        _star(
                          const Color(0xFFA89CC4),
                          17,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
