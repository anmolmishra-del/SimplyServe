
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplyserve/service/auth_service.dart';
import 'login_state.dart';

import 'package:simplyserve/service/token_manager.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool obscure = true;

  LoginCubit() : super(const LoginState());

  void toggleObscure() {
    obscure = !obscure;
    emit(state.copyWith()); // emit same state to trigger rebuilds where needed
  }

  String _buildUsername() {
    final email = emailCtrl.text.trim();
    if (email.isNotEmpty && email.contains('@')) return email.split('@').first;
    final phone = phoneCtrl.text.trim();
    if (phone.isNotEmpty) return 'user$phone';
    return 'user${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Sign in using ApiService.post("/auth/login", payload)
  /// Adjust endpoint & payload to match your backend.
  Future<void> signIn(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    final payload = {
      // send all fields — backend can ignore what it doesn't need
      // "username": _buildUsername(),
      // "password": passwordCtrl.text,
      // "email": emailCtrl.text.trim(),
      "phone_number": "+91"+phoneCtrl.text.trim(),
    };

    try {
      final res = await ApiService.post("/auth/send-otp", payload);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);

        final token = data['token'] ??
            data['access_token'] ??
            (data['data'] is Map ? data['data']['token'] : null);

        if (token != null) await TokenManager.saveToken(token.toString());

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
      
        if ((data['user'] is Map) && data['user']['name'] != null) {
          await prefs.setString('user_name', data['user']['name'].toString());
        } else if (emailCtrl.text.trim().isNotEmpty) {
          await prefs.setString('user_name', emailCtrl.text.trim());
        }
        if ((data['user'] is Map) && data['user']['email'] != null) {
          await prefs.setString('user_email', data['user']['email'].toString());
        } else if (emailCtrl.text.trim().isNotEmpty) {
          await prefs.setString('user_email', emailCtrl.text.trim());
        }
        if (phoneCtrl.text.trim().isNotEmpty) {
          await prefs.setString('user_phone', phoneCtrl.text.trim());
        }

        emit(state.copyWith(status: LoginStatus.success));
      } else {
        String message = 'Login failed: ${res.statusCode}';
        try {
          final body = jsonDecode(res.body);
          if (body is Map) {
            if (body.containsKey('message')) message = body['message'].toString();
            else if (body.containsKey('error')) message = body['error'].toString();
            else if (body.containsKey('detail')) message = body['detail'].toString();
            else if (body.containsKey('errors')) message = body['errors'].toString();
            else message = body.toString();
          } else {
            message = res.body.toString();
          }
        } catch (_) {
          message = res.body.toString();
        }
        emit(state.copyWith(status: LoginStatus.failure, errorMessage: message));
      }
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    phoneCtrl.dispose();
    return super.close();
  }
}
