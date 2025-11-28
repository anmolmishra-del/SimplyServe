import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';

class GradientButton extends StatelessWidget {
  /// If [child] is provided it will be used. Otherwise [text] is shown.
  final String text;
  final Widget? child;
  final VoidCallback? onPressed; // nullable so button can be disabled
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final Gradient? gradient;
  final Color textColor;

  const GradientButton({
    Key? key,
    this.text = '',
    this.child,
    required this.onPressed,
    this.height = 56,
    this.borderRadius = 12,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w700,
    this.gradient,
    this.textColor = AppColors.white,
  }) : super(key: key);

  Gradient get _defaultGradient => gradient ??
      const LinearGradient(
        colors: [AppColors.gradientColour, AppColors.primary],
      );

  Gradient get _disabledGradient => const LinearGradient(
        colors: [Color(0xFFEBEBEB), Color(0xFFDDDDDD)],
      );

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          // Keep splash/overlay behavior but ensure button uses our gradient
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          elevation: MaterialStateProperty.all(isDisabled ? 0 : 6),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(
            AppColors.primary.withOpacity(isDisabled ? 0.0 : 0.3),
          ),
          // ensure minimum size / alignment behavior of ElevatedButton doesn't interfere
          minimumSize: MaterialStateProperty.all(Size(double.infinity, height)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: isDisabled ? _disabledGradient : _defaultGradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            alignment: Alignment.center,
            child: child ??
                Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: isDisabled ? Colors.black45 : textColor,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
