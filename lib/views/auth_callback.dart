import 'package:flutter/material.dart';
import 'package:event_management_app/views/homepage.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({Key? key}) : super(key: key);

  @override
  _AuthCallbackPageState createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  @override
  void initState() {
    super.initState();
    // Redirect to homepage after successful authentication
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
