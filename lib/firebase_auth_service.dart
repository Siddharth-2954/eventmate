import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '1008968504628-cg8s9gcuckn4e9vjeu71ds9hf9nioom3.apps.googleusercontent.com' // Replace with your web client ID
        : null, // For mobile platforms, client ID is not needed
    scopes: ['profile', 'email'],
  );

  // Sign in with Google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return {'success': false, 'message': 'Sign in was cancelled by user'};
      }

      try {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the credential
        final userCredential = await _auth.signInWithCredential(credential);
        return {
          'success': true,
          'message': 'Successfully signed in',
          'user': userCredential.user
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Failed to sign in with Google: ${e.toString()}'
        };
      }
    } on Exception catch (e) {
      return {
        'success': false,
        'message': 'An error occurred during Google sign-in: ${e.toString()}'
      };
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
