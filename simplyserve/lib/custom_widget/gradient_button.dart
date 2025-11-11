import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final Gradient? gradient;
  final Color textColor;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height = 56,
    this.borderRadius = 12,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w700,
    this.gradient,
    this.textColor = AppColors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          elevation: MaterialStateProperty.all(6),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(AppColors.primary.withOpacity(0.3)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient ??
                const LinearGradient(
                  colors: [AppColors.gradientColour, AppColors.primary],
                ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
