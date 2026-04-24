import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lutheran/core/localization/app_localizations.dart';
import 'package:lutheran/core/services/local_bible_service.dart';
import 'package:lutheran/features/auth/presentation/pages/login_page.dart';
import 'package:lutheran/features/home/presentation/pages/home_page.dart';

/// Shown when the user is not signed in.
/// Displays a featured verse and lets the user choose to sign in
/// or continue offline as a guest.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final AnimationController _slideCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  LocalVerseResult? _verse;

  static const _kNavy   = Color(0xFF0D1B3E);
  static const _kPurple = Color(0xFF2D1B69);
  static const _kGold   = Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _fade  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _verse = LocalBibleService.verseOfDay();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeCtrl.forward();
        _slideCtrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  void _goSignIn() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (ctx, a, b) => const LoginPage(),
      transitionsBuilder: (ctx, anim, b, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 350),
    ));
  }

  void _continueOffline() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (ctx, a, b) => const HomePage(),
      transitionsBuilder: (ctx, anim, b, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 350),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_kNavy, _kPurple, Color(0xFF1A2456)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Logo + App Name ───────────────────────────────────
                  _AppLogo(),
                  const SizedBox(height: 12),
                  Text(
                    l.appName,
                    style: GoogleFonts.cinzel(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.appSubtitle,
                    style: GoogleFonts.lato(
                        fontSize: 13, color: Colors.white54, letterSpacing: 0.6),
                  ),

                  const Spacer(flex: 2),

                  // ── Verse of the Day card ─────────────────────────────
                  if (_verse != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _VerseCard(verse: _verse!, l: l),
                    ),

                  const Spacer(flex: 3),

                  // ── Action buttons ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        // Sign In
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: _goSignIn,
                            icon: const Icon(Icons.login_rounded, size: 20),
                            label: Text(
                              l.signIn,
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _kGold,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Continue offline
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton.icon(
                            onPressed: _continueOffline,
                            icon: const Icon(Icons.wifi_off_rounded, size: 18),
                            label: Text(
                              l.continueOffline,
                              style: GoogleFonts.lato(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 1.2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          l.offlineHint,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontSize: 11.5,
                              color: Colors.white38,
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),
                  const SizedBox(height: 12),
                  Text(
                    '© 2025 ${l.appSubtitle}',
                    style:
                        GoogleFonts.lato(fontSize: 10, color: Colors.white24),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();
  static const _kGold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2456), Color(0xFF0D1B3E)],
        ),
        border: Border.all(color: _kGold.withValues(alpha: 0.6), width: 2),
        boxShadow: [
          BoxShadow(
              color: _kGold.withValues(alpha: 0.25),
              blurRadius: 20,
              spreadRadius: 2),
        ],
      ),
      child: const Icon(Icons.church_rounded, size: 44, color: _kGold),
    );
  }
}

class _VerseCard extends StatelessWidget {
  final LocalVerseResult verse;
  final AppLocalizations l;
  const _VerseCard({required this.verse, required this.l});
  static const _kGold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _kGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: _kGold.withValues(alpha: 0.4)),
                ),
                child: Text(
                  l.verseOfDay,
                  style: GoogleFonts.lato(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: _kGold,
                      letterSpacing: 0.8),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.offline_bolt_rounded,
                  size: 14, color: Colors.white38),
              const SizedBox(width: 4),
              Text(l.offlineBadge,
                  style: GoogleFonts.lato(fontSize: 10, color: Colors.white38)),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '"${verse.text}"',
            style: GoogleFonts.notoSerif(
                fontSize: 14.5,
                fontStyle: FontStyle.italic,
                color: Colors.white.withValues(alpha: 0.88),
                height: 1.7),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.bookmark_rounded, size: 13, color: _kGold),
              const SizedBox(width: 6),
              Text(verse.reference,
                  style: GoogleFonts.cinzel(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _kGold)),
            ],
          ),
        ],
      ),
    );
  }
}
