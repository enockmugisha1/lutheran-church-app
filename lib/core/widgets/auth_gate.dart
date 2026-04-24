import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lutheran/core/widgets/splash_screen.dart';
import 'package:lutheran/features/home/presentation/pages/home_page.dart';

/// Routes to:
/// - [HomePage]     when the user is signed in with Firebase
/// - [SplashScreen] when the user is not signed in — the splash lets them
///   sign in OR continue offline as a guest (no account needed for Bible,
///   Calendar, and Liturgy features)
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  static const _kNavy = Color(0xFF0D1B3E);
  static const _kGold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Branded loading screen while Firebase initialises
          return Scaffold(
            backgroundColor: _kNavy,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _kNavy,
                      border: Border.all(
                          color: _kGold.withValues(alpha: 0.5), width: 2),
                    ),
                    child: const Icon(Icons.church_rounded,
                        size: 36, color: _kGold),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(_kGold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return const HomePage();
        }
        // Not signed in — show splash with "Sign In" + "Continue offline"
        return const SplashScreen();
      },
    );
  }
}
