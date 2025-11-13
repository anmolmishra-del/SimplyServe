import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/const/image.dart';
import 'package:simplyserve/custom_widget/home_page_custom_code/home_Page_Custom_code.dart';
import 'package:simplyserve/screen/food_order/order_food_page.dart';
import 'package:simplyserve/screen/groceries/groceries_page.dart';
import 'package:simplyserve/screen/home/profile_page.dart';
import 'package:simplyserve/screen/hotel_booking/hotels_booking_page.dart';
import 'package:simplyserve/screen/location/change_location_page.dart';
import 'package:simplyserve/screen/notifications/notifications_page.dart';

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
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangeLocationPage(),
                        ),
                      ),
                      icon: Icon(Icons.location_city),

                      color: AppColors.black,
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsPage(),
                          ),
                        );
                      },
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
                    Image.asset(AppImage.offerHomePage),
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
                  children: [
                    FeatureIcon(
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrderFoodPage(),
                          ),
                        );
                      },
                      image: AppImage.orderFoodIcon,
                      label: 'Order Food',
                    ),
                    FeatureIcon(
                      onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GroceriesPage(),
                          ),
                        );
                      },
                      image: AppImage.shopGroceriesIcon,
                      label: 'Shop Groceries',
                    ),
                    FeatureIcon(
                      onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HotelsBookingPage(),
                          ),
                        );
                      },
                      image: AppImage.bookHotelIcon,
                      label: 'Book Hotels',
                    ),
                    // FeatureIcon(
                    //   image: AppImage.profileIcon,
                    //   label: 'Profile',
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => const ProfilePage(),
                    //       ),
                    //     );
                    //   },
                    // ),
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
