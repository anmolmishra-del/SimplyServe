import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/const/image.dart';
import 'package:simplyserve/custom_widget/custom_textfromfiled.dart';
import 'package:simplyserve/custom_widget/gradient_button.dart';
import 'package:simplyserve/custom_widget/social_button.dart';
import 'package:simplyserve/screen/landing_page/login.dart';
import 'package:simplyserve/screen/landing_page/signup_page.dart';

class LoginLandingPage extends StatefulWidget {
  const LoginLandingPage({super.key});

  @override
  State<LoginLandingPage> createState() => _LoginLandingPageState();
}

class _LoginLandingPageState extends State<LoginLandingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      // Replace this with your authentication logic
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logging in...')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final cardWidth = mq.width * 0.92;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Container(
            width: cardWidth > 500 ? 420 : cardWidth,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                  blurRadius: 30,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: ()=>Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Continue as Guest',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 22),
                  Divider(
                    thickness: 1,
                    height: 8,
                    color: AppColors.lightGrey.withOpacity(0.2),
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    controller: _emailController,
                    hint: 'Email',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.lightGrey,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Please enter your email';
                      // simple email check
                      if (!RegExp(r"^[^@\\s]+@[^@\\s]+\\.[^@\\s]+").hasMatch(v))
                        return 'Enter a valid email';
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  CustomTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.lightGrey,
                    ),
                    obscureText: _obscurePassword,
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Please enter your password';
                      if (v.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),

                  const SizedBox(height: 22),

                  GradientButton(text: 'Continue', onPressed: _onContinue),

                  const SizedBox(height: 22),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialCircle(
                        iconAsset: AppImage.google,
                        fallback: Icons.g_mobiledata,
                      ),
                      const SizedBox(width: 18),
                      SocialCircle(
                        iconAsset: AppImage.fb,
                        fallback: Icons.facebook,
                      ),
                      const SizedBox(width: 18),
                      SocialCircle(
                        iconAsset: AppImage.aaple,
                        fallback: Icons.apple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'By continuing, you agree to our Terms of Service and Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
