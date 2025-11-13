import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplyserve/screen/landing_page/login.dart';
import 'package:simplyserve/screen/onbording_page/onbording_page.dart';
import 'package:simplyserve/screen/landing_page/landing_page.dart'; // your home screen

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const LoginLandingPage();
        }

        return const LoginPage();
      },
    );
  }
}
