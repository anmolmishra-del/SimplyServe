// signup_cubit.dart
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplyserve/otp/otp_page.dart';
import 'package:simplyserve/service/auth_service.dart';
import 'signup_state.dart';

import 'package:simplyserve/service/token_manager.dart';

class SignupCubit extends Cubit<SignupState> {
  // Controllers moved into cubit so widget can be stateless
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  // Form key moved to cubit so it isn't recreated on rebuilds
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // UI flags
  bool obscurePass = true;
  bool obscureConfirm = true;
  bool acceptTerms = false;

  SignupCubit() : super(const SignupState());

  void toggleObscurePass() {
    obscurePass = !obscurePass;
    emit(state.copyWith()); // trigger UI rebuild
  }

  void toggleObscureConfirm() {
    obscureConfirm = !obscureConfirm;
    emit(state.copyWith());
  }

  void toggleAcceptTerms() {
    acceptTerms = !acceptTerms;
    emit(state.copyWith());
  }

  /// Helper to split full name into first and last name
  Map<String, String> _splitName(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return {'first': '', 'last': ''};
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return {'first': parts[0], 'last': ''};
    final first = parts.first;
    final last = parts.sublist(1).join(' ');
    return {'first': first, 'last': last};
  }

  String _buildUsername() {
    final email = emailCtrl.text.trim();
    if (email.isNotEmpty && email.contains('@')) {
      return email.split('@').first;
    }
    final name = nameCtrl.text.trim();
    if (name.isNotEmpty)
      return name.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    return 'user${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Performs sign up action using ApiService.post and handles token + prefs.
  Future<void> signUp(BuildContext context) async {
    // Guard client-side acceptance too
    if (!acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept Terms & Privacy Policy')),
      );
      return;
    }

    // Validate form (formKey kept in cubit to avoid rebuild issues)
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(status: SignupStatus.loading, errorMessage: null));

    final nameParts = _splitName(nameCtrl.text.trim());
    final payload = {
      "username": _buildUsername(),
      "password": passCtrl.text,
      "email": emailCtrl.text.trim(),
      "first_name": nameParts['first'],
      "last_name": nameParts['last'],
      "phone_number": phoneCtrl.text.trim(),
      "roles": [],
    };
    // final payload = {
    //   "username": "string",
    //   "password": "string",
    //   "email": "user@example.com",
    //   "first_name": "string",
    //   "last_name": "string",
    //   "phone_number": "string",
    //   "roles": [],
    // };
    try {
      // Change endpoint if your API uses a different path
      final res = await ApiService.post("/auth/register", payload);

      // check response
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);

        // if backend returns token, save it
        print(data);
        await sendOtp(context);
        // final token =
        //     data['token'] ??
        //     data['access_token'] ??
        //     (data['data'] is Map ? data['data']['token'] : null);
        // if (token != null) {
        //   await TokenManager.saveToken(token.toString());
        // }

        // persist user info in shared preferences
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setBool('is_logged_in', true);
        // await prefs.setString('user_name', nameCtrl.text.trim());
        // await prefs.setString('user_email', emailCtrl.text.trim());
        // await prefs.setString('user_phone', phoneCtrl.text.trim());

        // emit(state.copyWith(status: SignupStatus.success));
      } else {
        // try to extract a helpful message from body
        print(res.body);
        String message = 'Signup failed: ${res.statusCode}';
        try {
          final body = jsonDecode(res.body);
          if (body is Map) {
            if (body.containsKey('message'))
              message = body['message'].toString();
            else if (body.containsKey('error'))
              message = body['error'].toString();
            else if (body.containsKey('detail'))
              message = body['detail'].toString();
            else if (body.containsKey('errors'))
              message = body['errors'].toString();
            else
              message = body.toString();
          } else {
            message = res.body.toString();
          }
        } catch (_) {
          message = res.body.toString();
        }
        emit(
          state.copyWith(status: SignupStatus.failure, errorMessage: message),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    // dispose controllers
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    return super.close();
  }

  /// reset the cubit to initial (keeps controllers)
  void reset() {
    emit(const SignupState());
  }

  Future<void> sendOtp(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final phone = phoneCtrl.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter phone number")),
      );
      return;
    }

    emit(state.copyWith(status: SignupStatus.loading));

    final nameParts = _splitName(nameCtrl.text.trim());

    // Send this data to backend if needed
    final payload = {
      // "name": nameCtrl.text.trim(),
      // "email": emailCtrl.text.trim(),
      "phone_number": phone,
    };

    try {
      final res = await ApiService.post("/auth/send-otp", payload);

      if (res.statusCode == 200 || res.statusCode == 201) {
        //  emit(state.copyWith(status: SignupStatus.success));

        print(res);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpPage(mobile: phone, cubit: this),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            errorMessage: "Failed to send OTP",
          ),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.body)));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: e.toString(),
        ),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void verifyOtp(BuildContext context, String otp) async {
    final phone = phoneCtrl.text.trim();

    if (otp.isEmpty || otp.length < 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter valid OTP")));
      return;
    }

    emit(state.copyWith(status: SignupStatus.loading));

    final payload = {"phone_number": phone, "otp": otp};

    try {
      final res = await ApiService.post("/auth/verify-otp", payload);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // OTP correct
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP verified successfully")),
        );

     final data = jsonDecode(res.body);
            final token =
            data['token'] ??
            data['access_token'] ??
            (data['data'] is Map ? data['data']['token'] : null);
        if (token != null) {
          await TokenManager.saveToken(token.toString());
        }

      
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('user_name', nameCtrl.text.trim());
        await prefs.setString('user_email', emailCtrl.text.trim());
        await prefs.setString('user_phone', phoneCtrl.text.trim());

        emit(state.copyWith(status: SignupStatus.success));
    
        await signUp(context);
      } else {
        // OTP incorrect
        emit(state.copyWith(status: SignupStatus.failure));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Invalid OTP: ${res.body}")));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: e.toString(),
        ),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
