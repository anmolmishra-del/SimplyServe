import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final String? fallbackAsset;
  final bool showLoader;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
    this.fallbackAsset,
    this.showLoader = true,
  });

  bool get _isValidUrl {
    return imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValidUrl) {
      // fallback immediately if no URL or invalid
      return _buildFallback();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 150),
        placeholderFadeInDuration: const Duration(milliseconds: 100),
        progressIndicatorBuilder: (context, url, progress) {
          if (!showLoader) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey.shade200,
            );
          }
          return Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            color: Colors.grey.shade100,
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.orange.shade600,
                value: progress.progress,
              ),
            ),
          );
        },
        errorWidget: (context, url, error) => _buildFallback(),
      ),
    );
  }

  Widget _buildFallback() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: fallbackAsset != null
            ? Image.asset(
                fallbackAsset!,
                width: width,
                height: height,
                fit: fit,
              )
            : const Icon(Icons.broken_image, color: Colors.grey, size: 28),
      ),
    );
  }
}
