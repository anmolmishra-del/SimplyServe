// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:simplyserve/routes.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }


//   Future<void> logoutUser(BuildContext context) async {
//   final prefs = await SharedPreferences.getInstance();

//   await prefs.clear();
//   await FirebaseAuth.instance.signOut();

//   Navigator.pushNamedAndRemoveUntil(
//     context,
//     Routes.loginLanding,
//     (route) => false,
//   );
// }

//   Future<UserCredential> signInWithEmailPassword(
//     String email,
//     String password,
//   ) async {
//     try {
//       return await _auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password.trim(),
//       );
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.message ?? 'Login failed');
//     }
//   }


//   Future<void> signUpWithEmailPassword(
//     BuildContext context,
//     String email,
//     String password,
//   ) async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//             email: email.trim(),
//             password: password.trim(),
//           );

//       // Check if user is created successfully
//       if (userCredential.user != null) {
//         // Navigate to another page
//         print(userCredential.user);
//         Navigator.pushReplacementNamed(context, Routes.home);
//       } else {
//         // Something went wrong
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Signup failed')));
//       }
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.message ?? 'Signup failed')));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

import 'token_manager.dart';

class ApiService {
  static const String baseUrl = "https://suppositionless-geralyn-jovially.ngrok-free.dev";

  // GET Request
  static Future<http.Response> get(String endpoint) async {
    String? token = await TokenManager.getToken();

    return await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }

  // POST Request
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    String? token = await TokenManager.getToken();

    return await http.post(
      Uri.parse("$baseUrl$endpoint"),
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }

  // PUT Request
  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    String? token = await TokenManager.getToken();

    return await http.put(
      Uri.parse("$baseUrl$endpoint"),
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }

  // DELETE Request
  static Future<http.Response> delete(String endpoint) async {
    String? token = await TokenManager.getToken();

    return await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }
}
