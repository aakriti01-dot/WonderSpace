
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  // WonderSpace Theme
  static const Color cream = Color(0xFFFAF7F2);
  static const Color teal = Color(0xFF57958F);
  static const Color mustard = Color(0xFFD9B44F);
  static const Color terracotta = Color(0xFFC77B59);
  static const Color sage = Color(0xFF83A58A);
  static const Color lavender = Color(0xFFC8C1D4);
  static const Color darkText = Color(0xFF453D37);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // SEND RESET EMAIL
  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final error = await _authService.resetPassword(
      _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'If an account exists with this email, a password reset link will be sent.',
          ),
          backgroundColor: teal,
          duration: Duration(seconds: 5),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: terracotta,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 26,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Back Button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 35),

              // Decorative Illustration
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: lavender.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.mark_email_unread_rounded,
                        size: 60,
                        color: teal,
                      ),
                      Positioned(
                        top: 8,
                        right: 12,
                        child: Icon(
                          Icons.star_rounded,
                          size: 28,
                          color: mustard,
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 10,
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 23,
                          color: terracotta,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // Heading
              const Center(
                child: Text(
                  'Forgot Your Password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Description
              const Center(
                child: Text(
                  "No worries! It happens. Enter your registered "
                      "email address and we'll help you get back "
                      "to your WonderSpace adventures.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Color(0xFF776E64),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Email Label
              const Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 12),

              // Email Input
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: 'Enter your registered email',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFAAA29A),
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: teal,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFE8E1D8),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: teal,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your email address';
                    }

                    final emailRegex = RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    );

                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(height: 28),

              // Send Reset Link Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendResetLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: teal.withValues(
                      alpha: 0.6,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 23,
                    width: 23,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : const Text(
                    'Send Reset Link',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Back to Login
              Center(
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.pop(context),
                  child: const Text.rich(
                    TextSpan(
                      text: 'Remember your password? ',
                      style: TextStyle(
                        color: Color(0xFF776E64),
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: 'Back to Login',
                          style: TextStyle(
                            color: teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Footer
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: mustard,
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'Keep exploring. Keep imagining.',
                      style: TextStyle(
                        color: Color(0xFF8C8278),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Icon(
                      Icons.auto_awesome,
                      color: sage,
                      size: 17,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
