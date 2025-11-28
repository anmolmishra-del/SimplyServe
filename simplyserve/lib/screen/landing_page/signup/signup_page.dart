// signup_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/const/image.dart';
import 'package:simplyserve/custom_widget/custom_textfromfiled.dart';
import 'package:simplyserve/custom_widget/gradient_button.dart';
import 'package:simplyserve/routes.dart';

import 'signup_cubit.dart';
import 'signup_state.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  Widget _leadingIcon(IconData icon) =>
      Icon(icon, size: 22, color: Colors.black87);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final cardWidth = mq.width > 520 ? 520.0 : mq.width * 0.95;

    return BlocProvider(
      create: (_) => SignupCubit(),
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.failure && state.errorMessage != null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Signup failed'),
                content: Text(state.errorMessage!),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
                ],
              ),
            );
          } else if (state.status == SignupStatus.success) {
            Navigator.pushReplacementNamed(context, Routes.home);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.loginLanding);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: const Text(''),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Container(
                width: cardWidth,
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: _SignupForm(leadingIcon: _leadingIcon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  final Widget Function(IconData) leadingIcon;
  const _SignupForm({Key? key, required this.leadingIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();
    final formKey = cubit.formKey;

    // Small helper for input spacing
    const inputGap = SizedBox(height: 12);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo + title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 62,
                height: 62,
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
                      color: AppColors.primary.withOpacity(0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    AppImage.onlyLogo,
                    width: 34,
                    height: 34,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.room_service,
                      color: AppColors.white,
                      size: 28,
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

          const SizedBox(height: 16),

          const Text(
            'Create your account',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Please fill the details to create an account',
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 22),

          // Name
          CustomTextField(
            controller: cubit.nameCtrl,
            hint: 'Full Name',
            leadingIcon: leadingIcon(Icons.person_outline),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter full name' : null,
          ),
          inputGap,

          // Email
          CustomTextField(
            controller: cubit.emailCtrl,
            hint: 'Email',
            leadingIcon: leadingIcon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter email';
              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) return 'Enter a valid email';
              return null;
            },
          ),
          inputGap,

          // Phone
          CustomTextField(
            controller: cubit.phoneCtrl,
            hint: 'Phone Number',
            leadingIcon: leadingIcon(Icons.phone_outlined),
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter phone' : null,
          ),
          inputGap,

          // Password
          BlocBuilder<SignupCubit, SignupState>(
            builder: (context, state) {
              final isObscure = cubit.obscurePass;
              return CustomTextField(
                controller: cubit.passCtrl,
                hint: 'Password',
                leadingIcon: leadingIcon(Icons.lock_outline),
                obscureText: isObscure,
                trailing: GestureDetector(
                  onTap: () => cubit.toggleObscurePass(),
                  behavior: HitTestBehavior.translucent,
                  child: Icon(isObscure ? Icons.visibility_off : Icons.visibility, size: 20),
                ),
                validator: (v) => (v == null || v.length < 6) ? 'Password must be 6+ chars' : null,
              );
            },
          ),
          inputGap,

          // Confirm password
          BlocBuilder<SignupCubit, SignupState>(
            builder: (context, state) {
              final isObscure = cubit.obscureConfirm;
              return CustomTextField(
                controller: cubit.confirmCtrl,
                hint: 'Confirm Password',
                leadingIcon: leadingIcon(Icons.ios_share_outlined),
                obscureText: isObscure,
                trailing: GestureDetector(
                  onTap: () => cubit.toggleObscureConfirm(),
                  behavior: HitTestBehavior.translucent,
                  child: Icon(isObscure ? Icons.visibility_off : Icons.visibility, size: 20),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please confirm password';
                  if (v != cubit.passCtrl.text) return 'Passwords do not match';
                  return null;
                },
              );
            },
          ),
          const SizedBox(height: 10),

          // Terms checkbox
          BlocBuilder<SignupCubit, SignupState>(
            builder: (context, state) {
              final accepted = cubit.acceptTerms;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => cubit.toggleAcceptTerms(),
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFBDBDBD)),
                        color: accepted ? const Color(0xFFFFA500) : Colors.white,
                      ),
                      child: accepted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => cubit.toggleAcceptTerms(),
                      child: const Text(
                        'I agree to Terms & Privacy Policy',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 18),

          // Sign Up button with loading text
          BlocBuilder<SignupCubit, SignupState>(
            builder: (context, state) {
              final isLoading = state.status == SignupStatus.loading;
              return GradientButton(
                text: isLoading ? 'Please wait...' : 'Sign Up',
                onPressed: isLoading
                    ? null
                    : () async {
                        // Check acceptance & validation & password match
                        if (!cubit.acceptTerms) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please accept Terms & Privacy Policy')),
                          );
                          return;
                        }

                        // if (!(formKey.currentState?.validate() ?? false)) return;

                        // if (cubit.passCtrl.text != cubit.confirmCtrl.text) {
                        //   showDialog(
                        //     context: context,
                        //     builder: (context) => const AlertDialog(title: Text('Passwords do not match')),
                        //   );
                        //   return;
                        // }

                        await cubit.signUp(context);
                      },
                height: 56,
              );
            },
          ),

          const SizedBox(height: 18),

          // OR divider
          Row(
            children: const [
              Expanded(child: Divider(color: Color(0xFFECECEC))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Or sign up with', style: TextStyle(color: Colors.black54)),
              ),
              Expanded(child: Divider(color: Color(0xFFECECEC))),
            ],
          ),

          const SizedBox(height: 14),

          // Social buttons
          _SocialRowButton(icon: 'assets/images/google.png', label: 'Continue with Google', onTap: () {}),
          const SizedBox(height: 12),
          _SocialRowButton(icon: 'assets/images/facebook.png', label: 'Continue with Facebook', onTap: () {}),
          const SizedBox(height: 12),
          _SocialRowButton(icon: 'assets/images/apple.png', label: 'Continue with Apple', onTap: () {}),
        ],
      ),
    );
  }
}

class _SocialRowButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  const _SocialRowButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFECECEC)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  icon,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.account_circle),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }
}
