// lib/pages/hotels_booking_page.dart
import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/custom_widget/custom_cached_image.dart';
import 'package:simplyserve/screen/hotel_booking/hotel_detail_page.dart';

class HotelsBookingPage extends StatelessWidget {
  const HotelsBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HotelsBookingScaffold();
  }
}

class _HotelsBookingScaffold extends StatefulWidget {
  const _HotelsBookingScaffold();

  @override
  State<_HotelsBookingScaffold> createState() => _HotelsBookingScaffoldState();
}

class _HotelsBookingScaffoldState extends State<_HotelsBookingScaffold>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  // demo list (title, kind, rating, offer)
  final List<Map<String, dynamic>> _data = [
    {
      'title': 'Marriott · Hyderabad',
      'kind': 'Hotel',
      'rating': 4.6,
      'offer': '20% OFF on Stay',
      'image':
          'https://www.kayak.com.au/rimg/dimg/dynamic/23/2023/08/ec5c7bdd31ea06239894a6a6577836cc.webp',
    },
    {
      'title': 'Barbeque Nation',
      'kind': 'Restaurant',
      'rating': 4.5,
      'offer': 'Free Dessert on Dine-in',
      'image':
          'https://www.kayak.com.au/rimg/dimg/dynamic/23/2023/08/ec5c7bdd31ea06239894a6a6577836cc.webp',
    },
    {
      'title': 'Taj Deccan',
      'kind': 'Hotel',
      'rating': 4.2,
      'offer': '₹500 Cashback on Booking',
      'image':
          'https://www.kayak.com.au/rimg/dimg/dynamic/23/2023/08/ec5c7bdd31ea06239894a6a6577836cc.webp',
    },
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget _networkImage(
    String url, {
    double width = 60,
    double height = 60,
    BorderRadius? borderRadius,
  }) {
    final child = Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image, color: Colors.grey, size: 28),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius, child: child);
    }
    return child;
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // background image (full cover)
              Image.network(
                'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8aG90ZWx8ZW58MHx8MHx8fDA%3D&fm=jpg&q=60&w=3000',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(
                    0xFFFF6D20,
                  ), // fallback color if image fails
                ),
              ),

           
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                   
                    colors: [
                      const Color(0xFFFF8A00).withOpacity(0.85),
                      const Color(0xFFFF5C00).withOpacity(0.85),
                    ],
                  ),
                ),
              ),

          
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                   
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                    
                          Container(
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 230, 0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Center(
                                child: Text(
                                  'Trending Deals',
                                  style: TextStyle(
                                    color: Color(0xFFFF5C00),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Book Your Stay or\nDine Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Exclusive Offers Available!',
                            style: TextStyle(color: Color(0xFFFFF3EA)),
                          ),
                        ],
                      ),
                    ),

                    // optional: small decorative image on the right (rounded)
                    // if you don't want a separate image, comment this block out
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 110,
                        height: 110,
                        child: Image.network(
                          'https://images.unsplash.com/photo-1501117716987-c8e5b9f6d2d0?auto=format&fit=crop&w=800&q=60',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: ()=>     Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HotelDetailPage(),
                          ),
                        ),    child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            // image
            CustomCachedImage(
              imageUrl: 
              item['image'] as String,
              width: 64,
              height: 64,
             
            ),
      
            const SizedBox(width: 12),
      
          
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        item['kind'] as String,
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        (item['rating'] as double).toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                
                  Text(
                    (item['offer'] as String).split('\n').first,
                    style: const TextStyle(
                      color: Color(0xFFFF6D20),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(width: 8),
      
      
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
                ],
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  item['offer'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFFF6D20),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabContent(String tabName) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 12, bottom: 90),
      itemCount: _data.length + 1,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPromoBanner(),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Popular Deals',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          );
        }

        final item = _data[index - 1];
        return _buildListItem(item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // white background as screenshot
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  // const Icon(
                  //   Icons.location_on_outlined,
                  //   size: 18,
                  //   color: Colors.black54,
                  // ),
                  // const SizedBox(width: 8),
                  // const Expanded(
                  //   child: Text(
                  //     'Hyoebaaa, India',
                  //     style: TextStyle(color: Colors.black87),
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.notifications_none),
                  // ),
                ],
              ),
            ),

            // Large title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                      IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                  ),
                    Text(
                      'Hotel & Restaurant\nBooking',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 48,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search hotels or restaurants',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color(0xFFF6F7F8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                  ),
                ),
              ),
            ),

            // Tabs
            const SizedBox(height: 10),
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Hotels'),
                Tab(text: 'Restaurants'),
              ],
            ),

            // content area (tab views)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _tabContent('Hotels'),
                  Center(child: Text("No data")),
                  // _tabContent('Restaurants'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
