import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/const/image.dart';
import 'package:simplyserve/custom_widget/custom_textfromfiled.dart';
import 'package:simplyserve/custom_widget/gradient_button.dart';
import 'package:simplyserve/screen/home/buttom_navigation_bar_page.dart';
import 'package:simplyserve/screen/landing_page/landing_page.dart';
import 'package:simplyserve/service/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }


void _onSignUp() async {
  if (!_acceptTerms) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please accept Terms & Privacy Policy')),
    );
    return;
  }

  if (!(_formKey.currentState?.validate() ?? false)) return;

  final auth = AuthService();

  if (_passCtrl.text != _confirmCtrl.text) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Passwords do not match'),
      ),
    );
    return;
  }

  try {
    await auth.signUpWithEmailPassword(
      context,
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );


    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_name', _nameCtrl.text.trim());
    await prefs.setString('user_email', _emailCtrl.text.trim());
    await prefs.setString('user_phone', _phoneCtrl.text.trim());

    // Navigate to home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RootScaffold()),
    );
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(title: Text(e.toString())),
    );
  }
}





  Widget _leadingIcon(IconData icon) =>
      Icon(icon, size: 22, color: Colors.black87);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final cardWidth = mq.width > 520 ? 460.0 : mq.width * 0.92;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginLandingPage()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
            child: Form(
              key: _formKey,
              child: Column(
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

                  // Title
                  const Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'I agree to Terms & Privacy',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),

                  // Inputs list
                  CustomTextField(
                    controller: _nameCtrl,
                    hint: 'Full Name',
                    leadingIcon: _leadingIcon(Icons.person_outline),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter full name'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _emailCtrl,
                    hint: 'Email',
                    leadingIcon: _leadingIcon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Please enter email';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v))
                        return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _phoneCtrl,
                    hint: 'Phone Number',
                    leadingIcon: _leadingIcon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter phone'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _passCtrl,
                    hint: 'Password',
                    leadingIcon: _leadingIcon(Icons.lock_outline),
                    obscureText: _obscurePass,
                    trailing: GestureDetector(
                      onTap: () => setState(() => _obscurePass = !_obscurePass),
                      child: Icon(
                        _obscurePass ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 6)
                        ? 'Password must be 6+ chars'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _confirmCtrl,
                    hint: 'Confirm Password',
                    leadingIcon: _leadingIcon(
                      Icons.ios_share_outlined,
                    ), // simple icon for confirm
                    obscureText: _obscureConfirm,
                    trailing: GestureDetector(
                      onTap: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      child: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Please confirm password';
                      if (v != _passCtrl.text) return 'Passwords do not match';
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // Terms checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => _acceptTerms = !_acceptTerms),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFBDBDBD)),
                            color: _acceptTerms
                                ? const Color(0xFFFFA500)
                                : Colors.white,
                          ),
                          child: _acceptTerms
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _acceptTerms = !_acceptTerms),
                          child: const Text(
                            'I agree to Terms & Privacy Policy',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Sign Up button
                  GradientButton(
                    text: 'Sign Up',
                    onPressed: _onSignUp,
                    height: 56,
                  ),

                  const SizedBox(height: 18),

                  // OR divider
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Color(0xFFECECEC))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Or sign up with',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFFECECEC))),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Social single-column: icon at left + label to right (like screenshot)
                  _SocialRowButton(
                    icon: 'assets/images/google.png',
                    label: 'Continue with Google',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _SocialRowButton(
                    icon: 'assets/images/facebook.png',
                    label: 'Continue with Facebook',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _SocialRowButton(
                    icon: 'assets/images/apple.png',
                    label: 'Continue with Apple',
                    onTap: () {},
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
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
