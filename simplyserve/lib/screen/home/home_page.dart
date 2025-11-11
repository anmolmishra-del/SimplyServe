import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/const/image.dart';
import 'package:simplyserve/custom_widget/home_page_custom_code/home_Page_Custom_code.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_city,
                      size: 20,
                      color: AppColors.black
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Hiydaravan,',
                        style: TextStyle(color: AppColors.black),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

      
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hi, Praveen 👋',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFECECEC)),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 18,
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: kMuted),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Search for food, groceries or hotels',
                              style: TextStyle(color: kMuted),
                            ),
                          ),
                        ],
                      ),
                    ),
                   
                  ],
                ),
              ),

          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    // PromoCard(
                    //   height: 88,
                    //   imageAsset: 'assets/images/promo_groceries.png',
                    //   title: 'Get 20% off on groceries\nthis week!',
                    //   onTap: () {},
                    // ),
                    const SizedBox(height: 12),
                    Image.asset(AppImage.offerHomePage)
                    // PromoCard(
                    //   height: 88,
                    //   imageAsset: 'assets/images/promo_food.png',
                    //   title: 'Free delivery on your\nfirst food order!',
                    //   onTap: () {},
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    FeatureIcon(image: AppImage.orderFoodIcon, label: 'Order Food'),
                    FeatureIcon(
                     image: AppImage.shopGroceriesIcon,
                      label: 'Shop Groceries',
                    ),
                    FeatureIcon(image: AppImage.bookHotelIcon, label: 'Book Hotels'),
                    FeatureIcon(image: AppImage.profileIcon, label: 'Profile'),
                  ],
                ),
              ),

              const SizedBox(height: 22),

         
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    SectionHeader(title: 'Popular Near You', onTap: () {}),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ListCard(
                            imagePath: AppImage.item1,
                            title: 'Top Rated Restaurants',
                            subtitle: 'Mar 22',
                            trailingText: 'View Booking',
                            onTapAction: () {},
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    SectionHeader(title: 'Last Food Order', onTap: () {}),
                    const SizedBox(height: 12),

                    ListCard(
                      imagePath: AppImage.item1,
                      title: 'Meghana Foods',
                      subtitle: 'Reorder',
                      trailingText: 'Reorder',
                      onTapAction: () {},
                    ),
                    ListCard(
                      imagePath: AppImage.item2,
                      title: 'So The Sky Kitchen',
                      subtitle: 'Reorder',
                      trailingText: 'Reorder',
                      onTapAction: () {},
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
