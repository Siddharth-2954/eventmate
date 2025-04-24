import 'dart:io';

import 'package:event_management_app/utils/saved_data.dart';
import 'package:event_management_app/views/auth_callback.dart';
import 'package:event_management_app/views/checkSessions.dart';
import 'package:event_management_app/views/homepage.dart';
import 'package:event_management_app/views/login.dart';
import 'package:event_management_app/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:event_management_app/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SavedData.init();
  await FirebaseConfig.initializeFirebase();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo app',
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(textTheme: GoogleFonts.interTextTheme()),
      initialRoute: '/',
      routes: {
        '/': (context) => const CheckSessions(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const Homepage(),
        '/auth-callback': (context) => const AuthCallbackPage(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
