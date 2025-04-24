import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '1008968504628-cg8s9gcuckn4e9vjeu71ds9hf9nioom3.apps.googleusercontent.com'
        : null,
    scopes: [
      'email',
      'profile',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  // Sign in with Google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Create a new provider
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/userinfo.email');
        googleProvider
            .addScope('https://www.googleapis.com/auth/userinfo.profile');

        // Trigger the auth flow
        final UserCredential userCredential =
            await _auth.signInWithPopup(googleProvider);

        return {
          'success': true,
          'message': 'Successfully signed in',
          'user': userCredential.user
        };
      } else {
        // Handle mobile sign-in
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          return {'success': false, 'message': 'Sign in was cancelled by user'};
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        return {
          'success': true,
          'message': 'Successfully signed in',
          'user': userCredential.user
        };
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
      return {
        'success': false,
        'message': 'Failed to sign in with Google: ${e.toString()}'
      };
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    if (kIsWeb) {
      await _googleSignIn.signOut();
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
