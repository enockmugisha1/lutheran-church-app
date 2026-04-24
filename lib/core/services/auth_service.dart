import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  // Only used on mobile — web uses signInWithPopup instead
  static final GoogleSignIn? _googleSignIn = kIsWeb ? null : GoogleSignIn();

  // ── Current user ──────────────────────────────────────────────────────────
  static User? get currentUser => _auth.currentUser;
  static bool get isLoggedIn => _auth.currentUser != null;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Email / Password ──────────────────────────────────────────────────────
  static Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    String language = 'rw',
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email, password: password,
    );
    await cred.user?.updateDisplayName(displayName);
    await _createUserDoc(cred.user!, displayName: displayName, language: language);
    return cred;
  }

  static Future<UserCredential?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email, password: password,
    );
    await _touchLastActive(cred.user!.uid);
    return cred;
  }

  // ── Google Sign-In ────────────────────────────────────────────────────────
  static Future<UserCredential?> signInWithGoogle() async {
    UserCredential cred;

    if (kIsWeb) {
      // Web: Firebase popup — no client ID meta tag required
      final provider = GoogleAuthProvider();
      cred = await _auth.signInWithPopup(provider);
    } else {
      // Mobile: use google_sign_in package
      final googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      cred = await _auth.signInWithCredential(credential);
    }

    // Create Firestore profile on first sign-in, else just update lastActive
    final doc = await _db.collection('users').doc(cred.user!.uid).get();
    if (!doc.exists) {
      await _createUserDoc(
        cred.user!,
        displayName: cred.user!.displayName ?? 'User',
      );
    } else {
      await _touchLastActive(cred.user!.uid);
    }
    return cred;
  }

  // ── Sign out ──────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    await _googleSignIn?.signOut(); // null-safe: skipped on web
    await _auth.signOut();
  }

  // ── Password reset ────────────────────────────────────────────────────────
  static Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ── Firestore user profile ────────────────────────────────────────────────
  static Future<void> _createUserDoc(
    User user, {
    String? displayName,
    String language = 'rw',
  }) async {
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'displayName': displayName ?? user.displayName ?? 'User',
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? '',
      'language': language,
      'church': 'LCR',
      'bio': '',
      'streak': 0,
      'longestStreak': 0,
      'followersCount': 0,
      'followingCount': 0,
      'joinedAt': FieldValue.serverTimestamp(),
      'lastActiveAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> _touchLastActive(String uid) async {
    await _db.collection('users').doc(uid).update({
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  static Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? church,
    String? language,
  }) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    final updates = <String, dynamic>{};
    if (displayName != null) updates['displayName'] = displayName;
    if (bio != null) updates['bio'] = bio;
    if (church != null) updates['church'] = church;
    if (language != null) updates['language'] = language;
    await _db.collection('users').doc(uid).update(updates);
    if (displayName != null) await currentUser?.updateDisplayName(displayName);
  }

  // ── Delete account ────────────────────────────────────────────────────────
  // Deletes the Firestore user document and the Firebase Auth account.
  // Requires recent authentication; caller must handle FirebaseAuthException
  // with code 'requires-recent-login' and prompt reauthentication.
  static Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final uid = user.uid;
    await _db.collection('users').doc(uid).delete();
    await user.delete();
  }
}
