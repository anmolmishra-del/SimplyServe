// lib/screen/groceries/groceries_page.dart
import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/const/image.dart';
import 'package:simplyserve/custom_widget/custom_cached_image.dart';
import 'package:simplyserve/screen/groceries/model/groceries_page_model.dart';

class GroceriesPage extends StatefulWidget {
  const GroceriesPage({super.key});

  @override
  State<GroceriesPage> createState() => _GroceriesPageState();
}

class _GroceriesPageState extends State<GroceriesPage> {
  // Mock categories + items
  final Map<String, List<Product>> _sections = {
    'Fruits & Vegetables': [
      Product(name: 'Fresh Apples', price: 120, image: AppImage.item1),
      Product(name: 'Tomatoes', price: 30, image: AppImage.item2),
      Product(name: 'Coca-Cola', price: 38, image: AppImage.item3),
      Product(name: 'Dairy Milk', price: 40, image: AppImage.item1),
      Product(name: 'Tropicana', price: 110, image: AppImage.item1),
      Product(name: 'Butter', price: 65, image: AppImage.item1),
    ],
    'Dairy & Bakery': [
      Product(name: 'Amul Milk', price: 70, image: AppImage.item1),
      Product(name: 'Bread', price: 30, image: AppImage.item1),
      Product(name: 'Paneer', price: 180, image: AppImage.item1),
    ],
  };

  // Demo horizontal offer cards
  final List<OfferCardModel> _offers = [
    OfferCardModel(
      title: 'Flat 20% OFF\non Fresh Fruits',
      image: AppImage.offers1,
    ),
    OfferCardModel(
      title: 'Buy 1 Get 1\nFree on Snacks',
      image: AppImage.offers2,
    ),
    OfferCardModel(
      title: 'Up to 40% OFF\non Daily Essentials',
      image: AppImage.offers3,
    ),
  ];

  // Cart state
  final Map<Product, int> _cart = {};

  // Search and filters (basic)
  String _searchQuery = '';
  String _activeSection = '';

  void _addToCart(Product p) => setState(() => _cart[p] = (_cart[p] ?? 0) + 1);
  void _removeFromCart(Product p) {
    if (!_cart.containsKey(p)) return;
    setState(() {
      if (_cart[p]! <= 1)
        _cart.remove(p);
      else
        _cart[p] = _cart[p]! - 1;
    });
  }

  int get _totalItems => _cart.values.fold(0, (a, b) => a + b);
  int get _totalPrice {
    var s = 0;
    _cart.forEach((p, qty) => s += p.price * qty);
    return s;
  }

  // Filtered items per section based on search query
  List<Product> _filterList(List<Product> list) {
    if (_searchQuery.trim().isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  // void _openCartSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  //     ),
  //     builder: (c) {
  //       return SizedBox(
  //         height: 420,
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Column(
  //             children: [
  //               Container(
  //                 width: 36,
  //                 height: 6,
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey.shade300,
  //                   borderRadius: BorderRadius.circular(6),
  //                 ),
  //               ),
  //               const SizedBox(height: 12),
  //               const Text(
  //                 'Your Cart',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
  //               ),
  //               const SizedBox(height: 12),
  //               Expanded(
  //                 child: _cart.isEmpty
  //                     ? const Center(child: Text('Your cart is empty'))
  //                     : ListView.separated(
  //                         itemCount: _cart.length,
  //                         separatorBuilder: (_, __) => const Divider(),
  //                         itemBuilder: (context, i) {
  //                           final entry = _cart.entries.elementAt(i);
  //                           final product = entry.key;
  //                           final qty = entry.value;
  //                           return ListTile(
  //                             leading: ClipRRect(
  //                               borderRadius: BorderRadius.circular(8),
  //                               child: CustomCachedImage(
  //                                 imageUrl: product.image,
  //                                 width: 56,
  //                                 height: 56,
  //                                 fallbackAsset: AppImage.item1,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                             ),
  //                             title: Text(
  //                               product.name,
  //                               style: const TextStyle(
  //                                 fontWeight: FontWeight.w700,
  //                               ),
  //                             ),
  //                             subtitle: Text('₹${product.price}'),
  //                             trailing: Row(
  //                               mainAxisSize: MainAxisSize.min,
  //                               children: [
  //                                 IconButton(
  //                                   onPressed: () => _removeFromCart(product),
  //                                   icon: const Icon(
  //                                     Icons.remove_circle_outline,
  //                                   ),
  //                                 ),
  //                                 Text(
  //                                   '$qty',
  //                                   style: const TextStyle(
  //                                     fontWeight: FontWeight.w700,
  //                                   ),
  //                                 ),
  //                                 IconButton(
  //                                   onPressed: () => _addToCart(product),
  //                                   icon: const Icon(Icons.add_circle_outline),
  //                                 ),
  //                               ],
  //                             ),
  //                           );
  //                         },
  //                       ),
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     'Total ($_totalItems items):',
  //                     style: const TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w700,
  //                     ),
  //                   ),
  //                   Text(
  //                     '₹$_totalPrice',
  //                     style: const TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.w900,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 12),
  //               SizedBox(
  //                 width: double.infinity,
  //                 height: 48,
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text('Proceed to checkout (demo)'),
  //                       ),
  //                     );
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: AppColors.primary,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                   ),
  //                   child: const Text(
  //                     'Proceed to Checkout',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w800,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // small helper widget for offer card
  Widget _offerCard(OfferCardModel m) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFFFDF2EA),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            m.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            m.image,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // small top paddings to match screenshot
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // main scrollable content
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: const SizedBox(height: 12)),

                // Header: app name + big title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                           IconButton(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(Icons.arrow_back_ios),
                                      ),
                        Text(
                          'Shop Groceries',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Search field
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 48,
                      child: TextField(
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Search groceries, fruits, or essentials',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: const Color(0xFFF6F7F8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Promo banner
             SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 120,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
            AppColors.gradientColour,
            AppColors.primary
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Yellow "Trending Offer" tag
                        Container(
                          height: 28,
                          width: 160,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 230, 0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Center(
                            child: Text(
                              'Trending Offer',
                              style: TextStyle(
                                color: Color(0xFFFF5C00),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),
                        const Text(
                          'Weekend Mega Sale!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Save up to 50% on your\nfavorite grocery brands',
                          style: TextStyle(
                            color: Color(0xFFFFF3EA),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right image
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        AppImage.offers1,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
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
  ),
),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Filter/action chips row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          const SizedBox(width: 4),
                          _filterChip(icon: Icons.sort, label: 'Sort by Price'),
                          const SizedBox(width: 8),
                          _filterChip(
                            icon: Icons.filter_list,
                            label: 'Filter by Category',
                          ),
                          const SizedBox(width: 8),
                          _filterChip(icon: Icons.local_offer, label: 'Offers'),
                          const SizedBox(width: 8),
                          _filterChip(
                            icon: Icons.local_shipping,
                            label: 'Delivery',
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Horizontal offer cards
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _offers.length,
                      itemBuilder: (context, i) => _offerCard(_offers[i]),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 18)),

                // Sections (Fruits & Vegetables, Dairy & Bakery etc.)
                for (final entry in _sections.entries) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          //  TextButton(onPressed: () {}, child: const Text('Add', style: TextStyle(color: Colors.orange))),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: const SizedBox(height: 8)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    sliver: SliverToBoxAdapter(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 12,
                        children: _filterList(entry.value).map((p) {
                          final qty = _cart[p] ?? 0;
                          return _productCard(p, qty);
                        }).toList(),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 18)),
                ],

                // Extra bottom spacing so last row isn't hidden under the floating pill
                SliverToBoxAdapter(child: const SizedBox(height: 70)),
              ],
            ), // end CustomScrollView
            // Floating cart pill (must be inside Stack children)
            if (_totalItems > 0)
              Positioned(
                left: 24,
                right: 24,
                bottom: 16,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 52),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),

                        // flexible text area that won't overflow
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'View Cart  •  ₹$_totalPrice  ($_totalItems items)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),
                        const Icon(Icons.chevron_right, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ), // end Stack
      ), // end SafeArea
    ); // end Scaffold
  }

  Widget _filterChip({required IconData icon, required String label}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFECECEC)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.orange),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _productCard(Product p, int qty) {
    final cardSpacing = 30;
    final width = (MediaQuery.of(context).size.width - cardSpacing) / 2;

    const double trailingWidth = 78;

    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomCachedImage(
              imageUrl: p.image,
              width: 46,
              height: 46,
              fallbackAsset: AppImage.item1,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                p.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '₹${p.price}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 7),
                  SizedBox(
                    width: trailingWidth,
                    child: qty == 0
                        ? GestureDetector(
                            onTap: () => _addToCart(p),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.orange.shade200,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // minus
                                SizedBox(
                                  width: 18,
                                  height: 30,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                    onPressed: () => _removeFromCart(p),
                                  ),
                                ),

                                // qty
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  child: Text(
                                    '$qty',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // plus
                                SizedBox(
                                  width: 20,
                                  height: 30,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                    onPressed: () => _addToCart(p),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
