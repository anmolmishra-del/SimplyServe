
import 'package:flutter/material.dart';

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










class SocialCircle extends StatelessWidget {
  final String iconAsset;
  final IconData fallback;
  const SocialCircle({required this.iconAsset, required this.fallback});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: SizedBox(
          width: 40,
          height: 40,
          child: Image.asset(
            iconAsset,
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) => Icon(fallback, color: Colors.black87),
          ),
        ),
      ),
      foregroundColor: Colors.black,
    );
  }
}
