
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  static const cream = Color(0xFFFAF7F2);
  static const teal = Color(0xFF5D8A85);
  static const terracotta = Color(0xFFBA6D4D);
  static const mustard = Color(0xFFD9AE54);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      showMessage('Please enter your email and password.');
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      showMessage('Welcome back to WonderSpace! ✨');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        showMessage('Incorrect email or password. Please try again.');
      } else if (e.code == 'invalid-email') {
        showMessage('Please enter a valid email address.');
      } else {
        showMessage(e.message ?? 'Something went wrong. Please try again.');
      }
    } catch (_) {
      if (!mounted) return;
      showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage('Enter your email first to reset your password.');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      showMessage('Password reset email sent! Check your inbox.');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showMessage(e.message ?? 'Could not send reset email.');
    }
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: teal, size: 21),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFEFECE5).withValues(alpha: 0.55),
      hintStyle: GoogleFonts.nunito(
        color: const Color(0xFF9B978F),
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFE5DED2),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: teal, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    // Illustration
                    SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Colors.black,
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.65, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          'assets/images/wonderspace_login.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),

                    // Welcome section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          Text(
                            'Welcome back!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              color: teal,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Your next little adventure awaits.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: terracotta,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Sign in and let your imagination grow.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: const Color(0xFF8A867F),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Login form
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email address',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF5F625C),
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: inputDecoration(
                              hint: 'Enter your email',
                              icon: Icons.mail_outline_rounded,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            'Password',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF5F625C),
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => login(),
                            decoration: inputDecoration(
                              hint: 'Enter your password',
                              icon: Icons.lock_outline_rounded,
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: teal,
                                ),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: forgotPassword,
                              child: Text(
                                'Forgot password?',
                                style: GoogleFonts.nunito(
                                  color: teal,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: teal,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : Text(
                                "Let's Explore!",
                                style: GoogleFonts.fredoka(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Create account
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  color: const Color(0xFF77736C),
                                ),
                                children: [
                                  const TextSpan(
                                    text: "New to WonderSpace? ",
                                  ),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () {
                                        showMessage(
                                          'Sign-up screen coming next!',
                                        );
                                      },
                                      child: Text(
                                        'Create Account',
                                        style: GoogleFonts.nunito(
                                          color: terracotta,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Decorative footer
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: mustard,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Little minds. Big adventures.',
                            style: GoogleFonts.fredoka(
                              fontSize: 13,
                              color: const Color(0xFF9B978F),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: mustard,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
