import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lutheran/core/services/auth_service.dart';
import 'package:lutheran/core/services/unsplash_service.dart';
import 'package:lutheran/features/auth/presentation/pages/register_page.dart';
import 'package:lutheran/features/home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey  = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;
  String? _bgUrl;

  @override
  void initState() {
    super.initState();
    UnsplashService.getDailyUrl('login').then((url) {
      if (mounted) setState(() => _bgUrl = url);
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      await AuthService.loginWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      if (mounted) _goHome();
    } on Exception catch (e) {
      setState(() => _error = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleLogin() async {
    setState(() { _loading = true; _error = null; });
    try {
      final cred = await AuthService.signInWithGoogle();
      if (cred != null && mounted) _goHome();
    } on Exception catch (e) {
      setState(() => _error = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goHome() => Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePage()), (_) => false);

  String _friendlyError(String raw) {
    if (raw.contains('user-not-found') || raw.contains('wrong-password')) {
      return 'Invalid email or password.';
    }
    if (raw.contains('network')) return 'Check your internet connection.';
    return 'Something went wrong. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background ────────────────────────────────────────────────────
          _bgUrl != null
              ? CachedNetworkImage(
                  imageUrl: _bgUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => _fallbackBg(),
                  errorWidget: (_, _, _) => _fallbackBg(),
                )
              : _fallbackBg(),

          // ── Dark gradient overlay ─────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.80),
                  Colors.black.withValues(alpha: 0.92),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 52),

                  // Logo
                  Container(
                    width: 76, height: 76,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.30), width: 1.5),
                    ),
                    child: const Icon(
                      Icons.church_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'LCR',
                    style: GoogleFonts.cinzel(
                      fontSize: 34, fontWeight: FontWeight.w800,
                      color: Colors.white, letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Itorero rya Luteri mu Rwanda',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.65),
                      letterSpacing: 0.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Verse
                  Text(
                    '"Umwami ni umwungeri wanjye; ntazabura ikintu na kimwe."',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerif(
                      fontSize: 12, fontStyle: FontStyle.italic,
                      color: Colors.white.withValues(alpha: 0.50), height: 1.6,
                    ),
                  ),
                  Text(
                    '— Zaburi 23:1',
                    style: GoogleFonts.lato(
                      fontSize: 10, fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),

                  const SizedBox(height: 44),

                  // ── Form card ───────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.40),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign In',
                            style: GoogleFonts.cinzel(
                              fontSize: 20, fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),

                          _GlassField(
                            controller: _emailCtrl,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => (v == null || !v.contains('@'))
                                ? 'Enter a valid email' : null,
                          ),
                          const SizedBox(height: 14),
                          _GlassField(
                            controller: _passCtrl,
                            label: 'Password',
                            icon: Icons.lock_outline_rounded,
                            obscure: _obscure,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                size: 18,
                                color: Colors.white54,
                              ),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                            validator: (v) => (v == null || v.length < 6)
                                ? 'At least 6 characters' : null,
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => _showResetDialog(context),
                              child: Text(
                                'Forgot password?',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                          ),

                          if (_error != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.35)),
                              ),
                              child: Text(
                                _error!,
                                style: GoogleFonts.lato(
                                    fontSize: 12, color: Colors.red.shade300),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Sign In button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                disabledBackgroundColor: Colors.white38,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                elevation: 0,
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 22, height: 22,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.black54))
                                  : Text(
                                      'Injira / Sign In',
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Divider
                          Row(children: [
                            Expanded(child: Divider(
                                color: Colors.white.withValues(alpha: 0.18))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('or',
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: Colors.white38)),
                            ),
                            Expanded(child: Divider(
                                color: Colors.white.withValues(alpha: 0.18))),
                          ]),

                          const SizedBox(height: 18),

                          // Google button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton(
                              onPressed: _loading ? null : _googleLogin,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.30)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.07),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const _GoogleLogo(size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Continue with Google',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Register + Guest
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('No account? ',
                        style: GoogleFonts.lato(
                            fontSize: 13,
                            color: Colors.white54)),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterPage())),
                      child: Text('Register',
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _goHome,
                    child: Text(
                      'Continue as Guest',
                      style: GoogleFonts.lato(
                          fontSize: 12, color: Colors.white38),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackBg() => Container(color: const Color(0xFF0A0A0A));

  void _showResetDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Reset Password',
            style: GoogleFonts.lato(
                fontWeight: FontWeight.w700, color: Colors.white)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.20)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white54),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.06),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.lato(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.contains('@')) {
                await AuthService.sendPasswordReset(ctrl.text.trim());
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Password reset email sent')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Send', style: GoogleFonts.lato(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── Glassmorphic text field ───────────────────────────────────────────────────
class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _GlassField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.lato(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.lato(
            fontSize: 13, color: Colors.white54),
        prefixIcon: Icon(icon, size: 18, color: Colors.white54),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.white.withValues(alpha: 0.20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.60), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.red.withValues(alpha: 0.50)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorStyle: GoogleFonts.lato(
            fontSize: 11, color: Colors.red.shade300),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ── Google logo ───────────────────────────────────────────────────────────────
class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({this.size = 22});

  @override
  Widget build(BuildContext context) => SizedBox(
      width: size, height: size,
      child: CustomPaint(painter: _GoogleGPainter()));
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.36;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect.deflate(r * 0.18), -0.52, 1.57, false, paint);
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect.deflate(r * 0.18), 1.05, 1.57, false, paint);
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect.deflate(r * 0.18), 2.62, 1.57, false, paint);
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect.deflate(r * 0.18), 4.19, 1.05, false, paint);

    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.82, cy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = r * 0.36
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_GoogleGPainter _) => false;
}
