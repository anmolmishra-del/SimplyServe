// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:simplyserve/custom_widget/endpoint.dart';

// class AuthService {
//   // Send OTP
//   static Future<bool> sendOtp(String emailOrPhone) async {
//     final payload = {"email": emailOrPhone}; // or phone_number
//     final res = await http.post(
//       Uri.parse(Endpoint.sendOtp),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(payload),
//     );
//     return res.statusCode == 200 || res.statusCode == 201;
//   }

//   // Verify OTP
//   static Future<String?> verifyOtp(String emailOrPhone, String otp) async {
//     final payload = {"email": emailOrPhone, "otp": otp};
//     final res = await http.post(
//       Uri.parse(Endpoint.verifyOtp),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(payload),
//     );
//     if (res.statusCode == 200 || res.statusCode == 201) {
//       final data = jsonDecode(res.body);
//       return data['token'] ?? data['access_token'] ?? null;
//     }
//     return null;
//   }

//   // Register user
//   static Future<http.Response> register(Map<String, dynamic> payload) async {
//     return await http.post(
//       Uri.parse(Endpoint.registration),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(payload),
//     );
//   }
// }

// // }

// // /// Register User API Call
// // //   Future<http.Response> registerUser({
// // //     required String username,
// // //     required String password,
// // //     required String email,
// // //     required String firstName,
// // //     String? lastName,
// // //     String? phoneNumber,
// // //   }) async {
// // //     return await http.post(
// // //       Uri.parse(Endpoint.registration),
// // //       headers: {"Content-Type": "application/json"},
// // //       body: jsonEncode({
// // //         'username': username,
// // //         'password': password,
// // //         'email': email,
// // //         'first_name': firstName,
// // //         'last_name': lastName ?? "",
// // //         'phone_number': phoneNumber ?? "",
// // //       }),
// // //     );
// // //   }
// // // }
