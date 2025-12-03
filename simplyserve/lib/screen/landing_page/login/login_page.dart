// login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/const/image.dart';
import 'package:simplyserve/custom_widget/custom_textfromfiled.dart';
import 'package:simplyserve/custom_widget/gradient_button.dart';
import 'package:simplyserve/routes.dart';

import 'login_cubit.dart';
import 'login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _onSignUp(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.signup);
  }

  void _onForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final cardWidth = mq.width > 500 ? 420.0 : mq.width * 0.9;

    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure && state.errorMessage != null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Login Failed'),
                content: Text(state.errorMessage!),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
                ],
              ),
            );
          } else if (state.status == LoginStatus.success) {
            Navigator.pushReplacementNamed(context, Routes.home);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.white,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Builder(builder: (context) {
                final cubit = context.read<LoginCubit>();
                return Container(
                  width: cardWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      children: [
                        // Logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.gradientColour,
                                    AppColors.primary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  AppImage.onlyLogo,
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.contain,
                                  errorBuilder: (c, e, s) => const Icon(
                                    Icons.room_service,
                                    color: AppColors.white,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              'Simply Serve',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Sign in to your account',
                          style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 22),

                        // Phone/Email input (uses cubit's controllers)
                        CustomTextField(
                          controller: cubit.phoneCtrl, // moved to cubit
                          hint: 'Phone Number',
                          leadingIcon: const Icon(Icons.phone_outlined),
                          keyboardType: TextInputType.phone,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter phone' : null,
                        ),
                        const SizedBox(height: 14),

                        // Password (optional in UI; if you want visible make sure to include)
                        // CustomTextField(
                        //   controller: cubit.passwordCtrl,
                        //   hint: 'Password',
                        //   obscureText: cubit.obscure,
                        //   trailing: GestureDetector(
                        //     onTap: () => cubit.toggleObscure(),
                        //     child: Icon(cubit.obscure ? Icons.visibility_off : Icons.visibility, size: 20),
                        //   ),
                        //   validator: (v) => (v == null || v.isEmpty) ? 'Please enter password' : null,
                        // ),
                        const SizedBox(height: 20),

                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(
                        //     onPressed: () => _onForgotPassword(context),
                        //     style: TextButton.styleFrom(
                        //       padding: EdgeInsets.zero,
                        //       minimumSize: Size.zero,
                        //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        //     ),
                        //     child: const Text(
                        //       'Forgot password?',
                        //       style: TextStyle(
                        //         fontSize: 14,
                        //         color: Color(0xFF2563EB),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(height: 18),

                        // Continue Button
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            final isLoading = state.status == LoginStatus.loading;
                            return GradientButton(
                              text: isLoading ? 'Please wait...' : 'Continue',
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      await cubit.signIn(context);
                                    },
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        Row(
                          children: const [
                            Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'or',
                                style: TextStyle(color: Color(0xFF9CA3AF)),
                              ),
                            ),
                            Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Social login buttons
                        _SocialButton(
                          icon: AppImage.google,
                          text: 'Continue with Google',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _SocialButton(
                          icon: AppImage.fb,
                          text: 'Continue with Facebook',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _SocialButton(
                          icon: AppImage.aaple,
                          text: 'Continue with Apple',
                          onTap: () {},
                        ),

                        const SizedBox(height: 22),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, Routes.home);
                          },
                          child: const Text(
                            'Continue as Guest',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // NEW: Sign up prompt
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(color: Color(0xFF6B7280)),
                            ),
                            TextButton(
                              onPressed: () => _onSignUp(context),
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;

  const _SocialButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        child: Row(
          children: [
            Image.asset(icon, width: 28, height: 28, fit: BoxFit.contain),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
