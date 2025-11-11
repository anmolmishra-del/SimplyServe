

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final Widget? prefixIcon;   // older name used in some files
  final Widget? leadingIcon;  // used in signup page
  final Widget? suffixIcon;   // older name
  final Widget? trailing;     // used in signup page
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final EdgeInsets? margin;

  const CustomTextField({
    Key? key,
    this.controller,
    required this.hint,
    this.prefixIcon,
    this.leadingIcon,
    this.suffixIcon,
    this.trailing,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // prefer the explicit leadingIcon if provided, otherwise fallback to prefixIcon
    final Widget? _leading = leadingIcon ?? prefixIcon;
    // prefer trailing if provided, otherwise fallback to suffixIcon
    final Widget? _trailing = trailing ?? suffixIcon;

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          // Wrap icons in padding to keep consistent spacing
          prefixIcon: _leading == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 8.0),
                  child: IconTheme(data: const IconThemeData(size: 22), child: _leading),
                ),
          suffixIcon: _trailing == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconTheme(data: const IconThemeData(size: 20), child: _trailing),
                ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
