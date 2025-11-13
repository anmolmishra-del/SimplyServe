import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/const/image.dart';
import 'package:simplyserve/custom_widget/custom_cached_image.dart';
import 'package:simplyserve/custom_widget/home_page_custom_code/home_Page_Custom_code.dart';
import 'package:simplyserve/screen/food_order/order_detail_page.dart';

class OrderFoodPage extends StatefulWidget {
  const OrderFoodPage({super.key});

  @override
  State<OrderFoodPage> createState() => _OrderFoodPageState();
}

class _OrderFoodPageState extends State<OrderFoodPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allRestaurants = [
    {
      'name': 'Meghana Foods',
      'subtitle': 'Biryani, Indian',
      'rating': 4.6,
      'reviews': 25,
      'time': '5 min',
      'offer': '30% OFF',
      'image':
          'https://img.freepik.com/free-photo/abstract-blur-coffee-shop-cafe-interior_74190-6342.jpg',
    },
    {
      'name': 'Pizza Hub',
      'subtitle': 'Pizza, Italian',
      'rating': 4.5,
      'reviews': 30,
      'time': '30 min',
      'offer': 'Buy 1 Get 1',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpkOviOJghZktEZ3fhNqRiRHikiNycdW2Dvw&s',
    },
    {
      'name': 'Burger Stop',
      'subtitle': 'Salads, Healthy',
      'rating': 4.7,
      'reviews': 22,
      'time': '22 min',
      'offer': 'Free OFF',
      'image':
          'https://media.istockphoto.com/id/1145578527/photo/blur-image-of-fast-food-restaurant-use-for-defocused-background.jpg?s=612x612&w=0&k=20&c=vDambt1ORG-de-3etsAzmxZPT49Tk-VJp89GX84Zny8=',
    },
    {
      'name': 'Tandoori Nights',
      'subtitle': 'Mughlai, BBQ',
      'rating': 4.2,
      'reviews': 40,
      'time': '35 min',
      'offer': '25% OFF',
      'image':
          'https://img.freepik.com/free-photo/plate-lamb-kebabs-with-vegetables-bowl-red-sauce_188544-43095.jpg?semt=ais_hybrid&w=740&q=80',
    },
    {
      'name': 'Choco Bites',
      'subtitle': 'Desserts, Bakery',
      'rating': 4.9,
      'reviews': 120,
      'time': '18 min',
      'offer': '10% OFF',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8iEcjWeUP8YdnLfU4OmS1Y5Fqof0pCIcSYQ&s',
    },
  ];

  List<Map<String, dynamic>> _filteredRestaurants = [];

  @override
  void initState() {
    super.initState();
    _filteredRestaurants = _allRestaurants;
  }

  void _filterRestaurants(String query) {
    setState(() {
      _filteredRestaurants = _allRestaurants
          .where(
            (r) =>
                r['name'].toLowerCase().contains(query.toLowerCase()) ||
                r['subtitle'].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final promos = [
      {
        'image': 'https://cdn-icons-png.flaticon.com/512/4780/4780045.png',
        'title': '30% OFF on Biryani Spots',
      },
      {
        'image': 'https://cdn-icons-png.flaticon.com/512/1404/1404945.png',
        'title': 'Buy 1 Get 1 Free Pizza Week',
      },
      {
        'image': 'https://cdn-icons-png.flaticon.com/512/16836/16836056.png',
        'title': '20% OFF on Healthy Meals',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const Text(
                    'Order Food',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Search bar
              TextField(
                controller: _searchController,
                onChanged: _filterRestaurants,
                decoration: InputDecoration(
                  hintText: 'Search restaurants or cuisines...',
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

         
              Column(
                children: promos
                    .map(
                      (promo) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PromoCard(
                          height: 80,
                          imageAsset: promo['image']!,
                          title: promo['title']!,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tapped: ${promo['title']}'),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Restaurants',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${_filteredRestaurants.length} found',
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 10),

          
              Column(
                children: _filteredRestaurants.map((r) {
                  final isSpecial = r['offer']
                      .toString()
                      .toLowerCase()
                      .contains('buy');
                  final badgeBg = isSpecial
                      ? const Color(0xFFFFE9D6)
                      : const Color(0xFFF2F2F2);
                  final badgeColor = isSpecial
                      ? AppColors.primary
                      : Colors.black87;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Open ${r['name']}')),
                        // );

                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RestaurantDetailPageUiMatch(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          CustomCachedImage(
                            imageUrl: r['image'],
                            width: 80,
                            height: 80,
                            borderRadius: 12,
                            fallbackAsset: AppImage.item1,
                          ),
                          const SizedBox(width: 12),

                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  r['subtitle'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      r['rating'].toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('• ${r['reviews']}'),
                                    const SizedBox(width: 8),
                                    Text('• ${r['time']}'),
                                  ],
                                ),
                              ],
                            ),
                          ),

                       
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              r['offer'],
                              style: TextStyle(
                                color: badgeColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
