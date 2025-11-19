import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';


class TripCard extends StatelessWidget {
  final String title;
  final String dateRange;
  final String status;

  const TripCard({
    Key? key,
    required this.title,
    required this.dateRange,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color badgeColor =
        status == 'Approved' ? Colors.green : (status == 'Pending' ? AppColors.primary : Colors.grey);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFECECEC)),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.card_travel,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(dateRange, style: const TextStyle(color: AppColors.grey)),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(color: badgeColor),
            ),
          )
        ],
      ),
    );
  }
}
