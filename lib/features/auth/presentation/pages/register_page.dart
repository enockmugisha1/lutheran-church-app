import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lutheran/core/services/auth_service.dart';
import 'package:lutheran/features/home/presentation/pages/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String _lang = 'rw';
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      await AuthService.registerWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        displayName: _nameCtrl.text.trim(),
        language: _lang,
      );
      if (mounted) _goHome();
    } on Exception catch (e) {
      setState(() => _error = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePage()),
      (_) => false,
    );
  }

  String _friendlyError(String raw) {
    if (raw.contains('email-already-in-use')) {
      return 'Iyi email isanzwe ikoreshwa. / Email already in use.';
    }
    if (raw.contains('weak-password')) return 'Ijambo banga ni ricye cyane. / Password too weak.';
    return 'Hari ikosa. Ongera ugerageze. / Something went wrong.';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0E17) : const Color(0xFFF5F3EF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Iyandikishe / Register', style: GoogleFonts.lato(
                fontSize: 26, fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              )),
              const SizedBox(height: 4),
              Text(
                'Fungura konti ya LCR yawe. / Create your LCR account.',
                style: GoogleFonts.lato(fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.grey.shade600),
              ),
              const SizedBox(height: 28),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Field(
                      controller: _nameCtrl,
                      label: 'Izina / Display Name',
                      icon: Icons.person_outline,
                      isDark: isDark,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Injiza izina ryawe' : null,
                    ),
                    const SizedBox(height: 14),
                    _Field(
                      controller: _emailCtrl,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      isDark: isDark,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Injiza email nyayo' : null,
                    ),
                    const SizedBox(height: 14),
                    _Field(
                      controller: _passCtrl,
                      label: 'Ijambo banga / Password',
                      icon: Icons.lock_outline,
                      isDark: isDark,
                      obscure: _obscure,
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                            size: 20, color: Colors.grey),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) => (v == null || v.length < 6)
                          ? 'Nibura inyuguti 6 / At least 6 characters' : null,
                    ),
                    const SizedBox(height: 18),

                    // Language selector
                    Text('Ururimi / Language',
                        style: GoogleFonts.lato(
                          fontSize: 13, fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white70 : const Color(0xFF1A1A1A),
                        )),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _LangChip(code: 'rw', label: 'Kinyarwanda',
                            selected: _lang == 'rw', isDark: isDark,
                            onTap: () => setState(() => _lang = 'rw')),
                        const SizedBox(width: 10),
                        _LangChip(code: 'en', label: 'English',
                            selected: _lang == 'en', isDark: isDark,
                            onTap: () => setState(() => _lang = 'en')),
                        const SizedBox(width: 10),
                        _LangChip(code: 'fr', label: 'Français',
                            selected: _lang == 'fr', isDark: isDark,
                            onTap: () => setState(() => _lang = 'fr')),
                      ],
                    ),
                    const SizedBox(height: 20),

                    if (_error != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                        ),
                        child: Text(_error!,
                            style: GoogleFonts.lato(fontSize: 12, color: Colors.red.shade300)),
                      ),
                      const SizedBox(height: 16),
                    ],

                    SizedBox(
                      width: double.infinity, height: 52,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D1B3E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: _loading
                            ? const SizedBox(width: 22, height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5, color: Colors.white))
                            : Text('Iyandikishe / Register',
                                style: GoogleFonts.lato(
                                    fontSize: 15, fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Usanzwe ufite konti? / Already have an account? ',
                          style: GoogleFonts.lato(
                              fontSize: 13,
                              color: isDark ? Colors.white54 : Colors.grey.shade600)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text('Injira / Sign In',
                            style: GoogleFonts.lato(
                              fontSize: 13, fontWeight: FontWeight.w700,
                              color: const Color(0xFF5C6BC0),
                            )),
                      ),
                    ]),
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

class _LangChip extends StatelessWidget {
  final String code, label;
  final bool selected, isDark;
  final VoidCallback onTap;
  const _LangChip({required this.code, required this.label,
      required this.selected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF5C6BC0)
              : (isDark ? const Color(0xFF1E1C2A) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF5C6BC0)
                : (isDark ? Colors.white24 : Colors.grey.shade300),
          ),
        ),
        child: Text(label,
            style: GoogleFonts.lato(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: selected ? Colors.white
                  : (isDark ? Colors.white70 : const Color(0xFF1A1A1A)),
            )),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isDark;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller, required this.label,
    required this.icon, required this.isDark,
    this.obscure = false, this.suffixIcon,
    this.keyboardType, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.lato(
          color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: isDark ? Colors.white24 : Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5C6BC0), width: 2),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1C2A) : Colors.white,
        labelStyle: GoogleFonts.lato(fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
