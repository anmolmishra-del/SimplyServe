import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/const/image.dart';
import 'package:simplyserve/custom_widget/home_page_custom_code/home_Page_Custom_code.dart';
import 'package:simplyserve/custom_widget/offer_card.dart';
import 'package:simplyserve/custom_widget/quick_action.dart';
import 'package:simplyserve/custom_widget/trip_card.dart';
import 'package:simplyserve/screen/hotel_booking/hotels_booking_page.dart';
import 'package:simplyserve/screen/travel/flight_search.dart';

class TravelHome extends StatelessWidget {
  const TravelHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Travel',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.shopping_bag_rounded,
          //     color: AppColors.primary,
          //   ),
          // ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
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
                        'Search flights, hotels or destinations',
                        style: TextStyle(color: kMuted),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              //  PromoCard(
              //   title: 'Flat 30% OFF',
              //   subtitle: 'on Domestic Flights', height: 80, imageAsset: '', onTap:(){},
              // ),
              Image.asset(AppImage.travelOffer),
              const SizedBox(height: 16),

              Row(
                children:  [
                  Expanded(
                    child: QuickAction(label: 'Flights', icon: Icons.flight, onTap: () { 

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FlightSearchPage(),
                          ),
                        );
                     },),
                  ),
                  SizedBox(width: 10),

                  // Expanded(
                  //   child: QuickAction(label: 'Hotels', icon: Icons.hotel),
                  // ),
                  // SizedBox(width: 10),
                  Expanded(
                    child: QuickAction(label: 'Cab', icon: Icons.local_taxi, onTap: () {  },),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: QuickAction(
                      label: 'International Travel',
                      icon: Icons.public, onTap: () {  },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    OfferCard(
                      title: 'Flat ₹150 OFF',
                      subtitle: 'on Flights',
                      imageAsset:
                          'https://images.unsplash.com/photo-1488085061387-422e29b40080?q=80&w=1031&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ),
                    SizedBox(width: 12),
                    OfferCard(
                      title: '1 Night Free',
                      subtitle: 'On Hotels',
                      imageAsset:
                          'https://images.unsplash.com/photo-1498307833015-e7b400441eb8?q=80&w=928&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    ),
                    SizedBox(width: 12),
                    OfferCard(
                      title: 'Up to 40% OFF',
                      subtitle: 'International Trips',
                      imageAsset:
                          'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDl8fHRyYXZlbHxlbnwwfHwwfHx8MA%3D%3D',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              SectionHeader(title: 'Upcoming Trips', onTap: () {}),

              const SizedBox(height: 12),
              const TripCard(
                title: 'New York → London',
                dateRange: 'Apr 12 — Apr 18',
                status: 'Pending',
              ),

              const SizedBox(height: 12),
              const TripCard(
                title: 'Bengaluru → Mumbai',
                dateRange: 'May 02 — May 05',
                status: 'Approved',
              ),

              const SizedBox(height: 20),
              SectionHeader(title: 'Popular Destinations', onTap: () {}),
              const SizedBox(height: 12),

              // Horizontal list of destination cards
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 0, right: 6),
                  children: [
                    _popularDestinationCard(
                      'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=800&auto=format&fit=crop',
                      'Paris',
                      '30% OFF Hotels',
                    ),
                    _popularDestinationCard(
                      'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?q=80&w=800&auto=format&fit=crop',
                      'Dubai',
                      'Flat ₹500 OFF',
                    ),
                    _popularDestinationCard(
                      'https://explore-live.s3.eu-west-1.amazonaws.com/medialibraries/explore/explore-media/destinations/asia/singapore/singapore-main.jpg?ext=.jpg&width=1920&format=webp&quality=80&v=201704210902%201920w',
                      'Singapore',
                      '40% OFF Activities',
                    ),
                    // add more cards if needed
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SectionHeader(title: 'Recommended Hotels', onTap: () {

                 Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HotelsBookingPage(),
                          ),
                        );
              }),
              const SizedBox(height: 12),

              // Horizontal list of hotel cards
              SizedBox(
                height: 190,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 0, right: 6),
                  children: [
                    _hotelCard(
                      'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=800&auto=format&fit=crop',
                      'The Leela Palace',
                      4.8,
                      8999,
                    ),
                    _hotelCard(
                      'https://images.unsplash.com/photo-1551918120-9739cb430c6a?q=80&w=800&auto=format&fit=crop',
                      'Taj Lands End',
                      4.7,
                      10500,
                    ),
                    _hotelCard(
                      'https://images.unsplash.com/photo-1551776235-dde6d4829808?q=80&w=800&auto=format&fit=crop',
                      'Marriott Hotel',
                      4.6,
                      7800,
                    ),
                    
                    // add more cards if needed
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _popularDestinationCard(
    String imageUrl,
    String title,
    String subtitle,
  ) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade200,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.55),
              Colors.black.withOpacity(0.15),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hotelCard(String imageUrl, String name, double rating, int price) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
            child: Image.network(
              imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 110,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                );
              },
              errorBuilder: (ctx, _, __) {
                return Container(
                  height: 110,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                );
              },
            ),
          ),

          // Text content
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel Name
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 6),

                // Rating + price row
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(color: AppColors.grey),
                    ),
                    const Spacer(),
                    Text(
                      "₹$price / night",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
