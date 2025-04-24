import 'package:appwrite/appwrite.dart';
import 'package:event_management_app/database.dart';
import 'package:event_management_app/utils/saved_data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('64b4fc61e5f4aa023618');

Account account = Account(client);

// Register User
Future<String> createUser(String name, String email, String password) async {
  try {
    final user = await account.create(
        userId: ID.unique(), email: email, password: password, name: name);
    saveUserData(name, email, user.$id);
    return "success";
  } on AppwriteException catch (e) {
    return e.message.toString();
  }
}

// Login User
Future loginUser(String email, String password) async {
  try {
    final user =
        await account.createEmailSession(email: email, password: password);
    if (user.userId != null) {
      await SavedData.saveUserId(user.userId);
      await getUserData();
      return true;
    }
    return false;
  } on AppwriteException catch (e) {
    print("Login error: ${e.message}");
    return false;
  } catch (e) {
    print("Unexpected error during login: $e");
    return false;
  }
}

// Logout the user
Future logoutUser() async {
  try {
    await account.deleteSession(sessionId: 'current');
    await SavedData.clearSavedData();
  } catch (e) {
    print("Logout error: $e");
  }
}

// check if user have an active session or not
Future<bool> checkSessions() async {
  try {
    final session = await account.getSession(sessionId: 'current');
    return session.userId != null;
  } catch (e) {
    print("Session check error: $e");
    return false;
  }
}

// Sign in with Google
Future<bool> signInWithGoogle() async {
  try {
    // Create OAuth2 session with Appwrite
    final session = await account.createOAuth2Session(
      provider: 'google',
      success: 'http://localhost:54502/auth-callback',
      failure: 'http://localhost:54502/auth-callback',
      scopes: ['profile', 'email'],
    );

    if (session.userId != null) {
      await SavedData.saveUserId(session.userId);
      await getUserData();
      return true;
    }
    return false;
  } catch (e) {
    print("Google Sign-In error: $e");
    return false;
  }
}
