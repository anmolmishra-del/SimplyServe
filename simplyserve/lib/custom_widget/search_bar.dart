import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';


class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFECECEC)),
      ),
      child: Row(
        children: const [
          Icon(Icons.search, color: AppColors.grey),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Search flights, hotels or destinations',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
