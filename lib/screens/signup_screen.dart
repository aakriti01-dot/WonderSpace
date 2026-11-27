import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _auth = AuthService();

  bool _hidePassword = true;
  bool _hideConfirm = true;
  bool _acceptedTerms = false;
  bool _submitting = false;
  bool _registered = false;
  String? _status;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _pending(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }


  Future<void> _submit() async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      setState(() => _status = 'Accept the terms to create an account.');
      return;
    }

    setState(() {
      _submitting = true;
      _status = null;
      _registered = false;
    });

    try {
      final message = await _auth.register(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        confirmPassword: _confirm.text,
        acceptedTerms: _acceptedTerms,
      );

      if (!mounted) return;

      if (message != null) {
        setState(() {
          _status = message;
          _registered = false;
        });
        return;
      }

      // Clear the registration fields after success.
      _formKey.currentState!.reset();
      _name.clear();
      _email.clear();
      _password.clear();
      _confirm.clear();

      setState(() {
        _acceptedTerms = false;
        _registered = true;
      });

      // Show successful registration confirmation.
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFAF7F2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              'Welcome to WonderSpace!',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5D8A85),
              ),
            ),
            content: Text(
              'Your account has been created successfully. Your adventure starts here!',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 15,
                color: const Color(0xFF433946),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF5D8A85),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(150, 46),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Continue to Login'),
              ),
            ],
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Widget _visibilityButton({
    required bool hidden,
    required String field,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      tooltip: hidden ? 'Show $field' : 'Hide $field',
      onPressed: onPressed,
      icon: Icon(
        hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      ),
    );
  }

  Widget _provider(String label, String asset, IconData fallback) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () => _pending('$label sign-in integration pending.'),
        icon: SvgPicture.asset(
          asset,
          width: 18,
          height: 18,
          errorBuilder: (_, __, ___) => Icon(fallback, size: 18),
        ),
        label: Text(label),
      ),
    );
  }

  Widget _signupField({
    required TextEditingController controller,
    required String label,
    required FormFieldValidator<String> validator,
    TextInputType? keyboard,
    TextCapitalization capitalization = TextCapitalization.none,
    bool hidden = false,
    Widget? eye,
    bool last = false,
  }) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(26)),
      borderSide: BorderSide(color: Color(0xFFE5DED2)),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        readOnly: _submitting,
        validator: validator,
        keyboardType: keyboard,
        textCapitalization: capitalization,
        obscureText: hidden,
        autocorrect: eye == null,
        enableSuggestions: eye == null,
        textInputAction: last ? TextInputAction.done : TextInputAction.next,
        onFieldSubmitted: last ? (_) => _submit() : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0x8CEFECE5),
          labelStyle: const TextStyle(color: Color(0xFF6E5E66)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: Color(0xFF5D8A85), width: 2),
          ),
          suffixIcon: eye,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accountLinkColor = Color(0xFFBA6D4D);
    const ink = Color(0xFF433946);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: _SignupDoodleBackdrop(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  children: [
                    Center(child: _blendedSignupArtwork()),
                    const SizedBox(height: 12),
                    Text(
                      'Come on in, little explorer!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                        color: const Color(0xFF5D8A85),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "There's so much waiting for you to discover.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFBA6D4D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _provider(
                          'Google',
                          'assets/icons/google.svg',
                          Icons.public,
                        ),
                        const SizedBox(width: 8),
                        _provider(
                          'Facebook',
                          'assets/icons/facebook.svg',
                          Icons.facebook,
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('or sign up with email'),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    _signupField(
                      controller: _name,
                      label: 'Full name',
                      capitalization: TextCapitalization.words,
                      validator: (value) => (value ?? '').trim().isEmpty
                          ? 'Enter your name.'
                          : null,
                    ),
                    _signupField(
                      controller: _email,
                      label: 'Email address',
                      keyboard: TextInputType.emailAddress,
                      validator: (value) =>
                          RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                              .hasMatch((value ?? '').trim())
                          ? null
                          : 'Enter a valid email address.',
                    ),
                    _signupField(
                      controller: _password,
                      label: 'Enter password',
                      hidden: _hidePassword,
                      eye: _visibilityButton(
                        hidden: _hidePassword,
                        field: 'password',
                        onPressed: () =>
                            setState(() => _hidePassword = !_hidePassword),
                      ),
                      validator: (value) {
                        final length = (value ?? '').runes.length;
                        return length >= 8 && length <= 128
                            ? null
                            : 'Use 8 to 128 characters.';
                      },
                    ),
                    _signupField(
                      controller: _confirm,
                      label: 'Re-enter password',
                      hidden: _hideConfirm,
                      last: true,
                      eye: _visibilityButton(
                        hidden: _hideConfirm,
                        field: 'confirmation password',
                        onPressed: () =>
                            setState(() => _hideConfirm = !_hideConfirm),
                      ),
                      validator: (value) {
                        if ((value ?? '').isEmpty)
                          return 'Confirm your password.';
                        return value == _password.text
                            ? null
                            : 'Passwords do not match.';
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                        'I agree to the Terms of Service and Privacy Policy.',
                      ),
                      value: _acceptedTerms,
                      onChanged: _submitting
                          ? null
                          : (value) =>
                                setState(() => _acceptedTerms = value ?? false),
                    ),
                    if (_status != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          _status!,
                          style: TextStyle(
                            color: _registered ? ink : theme.colorScheme.error,
                          ),
                        ),
                      ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF5D8A85),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: _submitting ? null : _submit,
                      child: Text(
                        _submitting ? 'Creating account...' : 'Create account',
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              color: accountLinkColor,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
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

Widget _blendedSignupArtwork() {
  return LayoutBuilder(
    builder: (context, constraints) {
      const sidePadding = 24.0;
      final pageWidth = constraints.maxWidth + sidePadding * 2;

      // The visible artwork occupies 1750 of the PNG's 1920 pixels.
      final leftTrim = pageWidth * 98 / 1750;
      final rightTrim = pageWidth * 72 / 1750;
      final height = pageWidth * 819 / 1750;

      return SizedBox(
        width: constraints.maxWidth,
        height: height,
        child: OverflowBox(
          minWidth: pageWidth,
          maxWidth: pageWidth,
          child: SizedBox(
            width: pageWidth,
            height: height,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: -leftTrim,
                  right: -rightTrim,
                  top: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/wonderspace_signup_kids.png',
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _SignupDoodleBackdrop extends StatelessWidget {
  const _SignupDoodleBackdrop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0x52D9AE54);
    const sage = Color(0x52809676);
    const lilac = Color(0x52A594B5);
    const peach = Color(0x46BA6D4D);

    return Stack(
      fit: StackFit.passthrough,
      children: [
        const Positioned.fill(
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(-0.96, -0.65),
                    child: Icon(Icons.nightlight_round, color: gold, size: 17),
                  ),
                  Align(
                    alignment: Alignment(0.96, -0.54),
                    child: Icon(Icons.eco_outlined, color: sage, size: 18),
                  ),
                  Align(
                    alignment: Alignment(-0.96, -0.39),
                    child: Icon(
                      Icons.auto_stories_outlined,
                      color: lilac,
                      size: 16,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.97, -0.25),
                    child: Icon(
                      Icons.star_outline_rounded,
                      color: gold,
                      size: 15,
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.96, -0.09),
                    child: Icon(Icons.eco_outlined, color: sage, size: 17),
                  ),
                  Align(
                    alignment: Alignment(0.96, 0.08),
                    child: Icon(Icons.nightlight_round, color: lilac, size: 15),
                  ),
                  Align(
                    alignment: Alignment(-0.96, 0.25),
                    child: Icon(
                      Icons.star_outline_rounded,
                      color: peach,
                      size: 15,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.96, 0.42),
                    child: Icon(
                      Icons.auto_stories_outlined,
                      color: sage,
                      size: 16,
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.96, 0.63),
                    child: Icon(Icons.eco_outlined, color: sage, size: 17),
                  ),
                  Align(
                    alignment: Alignment(0.96, 0.80),
                    child: Icon(
                      Icons.star_outline_rounded,
                      color: gold,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
