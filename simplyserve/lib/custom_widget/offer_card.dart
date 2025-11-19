import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageAsset;

  const OfferCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),

     
        image:  DecorationImage(
          image: NetworkImage(
           imageAsset
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),

        // ⭐ Dark transparent overlay
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.45),
              Colors.black.withOpacity(0.15),
            ],
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
