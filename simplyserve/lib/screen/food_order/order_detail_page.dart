
import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/const/image.dart';
import 'package:simplyserve/custom_widget/custom_cached_image.dart';
import 'package:simplyserve/screen/food_order/model/food_order_model.dart';

class RestaurantDetailPageUiMatch extends StatefulWidget {
  const RestaurantDetailPageUiMatch({super.key});

  @override
  State<RestaurantDetailPageUiMatch> createState() => _RestaurantDetailPageUiMatchState();
}

class _RestaurantDetailPageUiMatchState extends State<RestaurantDetailPageUiMatch> {
  final List<MenuItem> _items = [
    MenuItem(
      id: '1',
      name: 'Chicken Dum Biryani',
      subtitle: 'Biryani • 400g',
      price: 220,
      rating: 4.7,
      image: 'https://ministryofcurry.com/wp-content/uploads/2024/06/chicken-biryani.jpg',
    ),
    MenuItem(
      id: '2',
      name: 'Mutton Biryani',
      subtitle: 'Spicy • 500g',
      price: 260,
      rating: 4.6,
      image: 'https://ministryofcurry.com/wp-content/uploads/2024/06/chicken-biryani.jpg',
    ),
    MenuItem(
      id: '3',
      name: 'Veg Biryani',
      subtitle: 'Healthy • 350g',
      price: 180,
      rating: 4.4,
      image: 'https://ministryofcurry.com/wp-content/uploads/2024/06/chicken-biryani.jpg',
    ),
    MenuItem(
      id: '4',
      name: 'Chicken 65',
      subtitle: 'Crispy • 250g',
      price: 200,
      rating: 4.6,
      image: 'https://ministryofcurry.com/wp-content/uploads/2024/06/chicken-biryani.jpg',
    ),
    MenuItem(
      id: '5',
      name: 'Paneer Butter Masala',
      subtitle: 'Creamy • 300g',
      price: 240,
      rating: 4.3,
      image: 'https://myfoodstory.com/wp-content/uploads/2021/07/Paneer-Butter-Masala-3.jpg',
    ),
  ];

  final Map<String, int> _cart = {};
  String _searchQuery = '';

  void _addItem(String id) => setState(() => _cart[id] = (_cart[id] ?? 0) + 1);
  void _removeItem(String id) {
    if (!_cart.containsKey(id)) return;
    setState(() {
      if (_cart[id]! <= 1) _cart.remove(id);
      else _cart[id] = _cart[id]! - 1;
    });
  }

  int get totalItems => _cart.values.fold(0, (a, b) => a + b);
  int get totalPrice {
    var s = 0;
    _cart.forEach((id, qty) {
      final it = _items.firstWhere((e) => e.id == id, orElse: () => _items[0]);
      s += it.price * qty;
    });
    return s;
  }

  Widget _addButton(MenuItem item) {
    final qty = _cart[item.id] ?? 0;
    if (qty == 0) {
      return SizedBox(
        height: 38,
        child: ElevatedButton(
          onPressed: () => _addItem(item.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary ,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
          child: const Text('ADD', style: TextStyle(color: AppColors.white,fontWeight: FontWeight.w800, fontSize: 14)),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(onTap: () => _removeItem(item.id), child: const Icon(Icons.remove, size: 18)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            InkWell(onTap: () => _addItem(item.id), child: const Icon(Icons.add, size: 18)),
          ],
        ),
      );
    }
  }

  void _openCartSheet() {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (_) {
        return SizedBox(
          height: 420,
          child: Column(
            children: [
              Container(width: 36, height: 6, margin: const EdgeInsets.only(top: 12), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(6))),
              const SizedBox(height: 12),
              const Text('Your Cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Expanded(
                child: _cart.isEmpty
                    ? const Center(child: Text('Your cart is empty'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _cart.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (ctx, i) {
                          final id = _cart.keys.elementAt(i);
                          final qty = _cart[id]!;
                          final item = _items.firstWhere((e) => e.id == id);
                          return ListTile(
                            leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: CustomCachedImage(imageUrl: item.image, width: 56, height: 56, fallbackAsset: AppImage.item1, fit: BoxFit.cover)),
                            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: Text('₹${item.price}'),
                            trailing: Text('x$qty', style: const TextStyle(fontWeight: FontWeight.w700)),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total (${totalItems} items)', style: const TextStyle(fontWeight: FontWeight.w700)), Text('₹$totalPrice', style: const TextStyle(fontWeight: FontWeight.w900))]),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proceed (demo)')));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('Proceed to Checkout', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  List<MenuItem> get _filtered {
    if (_searchQuery.trim().isEmpty) return _items;
    final q = _searchQuery.toLowerCase();
    return _items.where((e) => e.name.toLowerCase().contains(q) || e.subtitle.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
          
            CustomScrollView(
              slivers: [
             
                SliverToBoxAdapter(child: const SizedBox(height: 8)),

            
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                   
                      Row(children: const [
                        Icon(Icons.lens, size: 8, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Authentic Biryani & Indian\'s Cuisine', style: TextStyle(color: Colors.black54)),
                      ]),
                      const SizedBox(height: 8),

                    
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                          Expanded(
                            child: Text('Meghana Foods', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600, height: 1.0)),
                          ),
                      
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(onPressed: _openCartSheet, icon: const Icon(Icons.shopping_bag_outlined)),
                              if (totalItems > 0)
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                                    child: Text('$totalItems', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                    
                      Row(children: [
                        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.local_offer, size: 14, color: Colors.black54)),
                        const SizedBox(width: 10),
                        Row(children: const [Text('4.6', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(width: 6), Icon(Icons.star, size: 16, color: Colors.orange)]),
                        const SizedBox(width: 12),
                        Row(children: const [Icon(Icons.access_time, size: 14, color: Colors.black54), SizedBox(width: 6), Text('25 min', style: TextStyle(color: Colors.black54))]),
                        const SizedBox(width: 12),
                        Container(height: 16, width: 1, color: Color(0xFFE7E7E7)),
                        const SizedBox(width: 12),
                        const Text('₹200 for one', style: TextStyle(color: Colors.black54)),
                      ]),

                      const SizedBox(height: 12),

              
Stack(
  clipBehavior: Clip.none,
  children: [
 
    ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 92, 
        color: const Color(0xFFFFF1E7),
        child: Row(
          children: [
            const SizedBox(width: 16),
         
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '30% OFF on all orders today',
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
         
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: SizedBox(
                width: 140,
                height: 92,
                child: CustomCachedImage(
                  imageUrl: _items[0].image,
                  width: 140,
                  height: 92,
                  fallbackAsset: AppImage.item1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    ),


    Positioned(
      left: 16,
      right: 16,
      bottom: -24, 
      child: SizedBox(
        height: 48,
        child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: InputDecoration(
            hintText: 'Search in Meghana Foods',
            prefixIcon: const Icon(Icons.search, color: Colors.black54),
            filled: true,
            fillColor: const Color(0xFFF6F7F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    ),

  
  ],
)
,

                 
                      const SizedBox(height: 36),
                    ]),
                  ),
                ),

          
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                      Text('Popular Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      Icon(Icons.chevron_right, color: Colors.black26),
                    ]),
                  ),
                ),

         
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = filtered[index];
                        final qty = _cart[item.id] ?? 0;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                       
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 72,
                                      height: 72,
                                      child: CustomCachedImage(imageUrl: item.image, width: 72, height: 72, fallbackAsset: AppImage.item1, fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Row(children: [
                                        Expanded(child: Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
                                      
                                        const SizedBox(width: 6),
                                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                                      ]),
                                      const SizedBox(height: 8),
                                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                     
                                        const Icon(Icons.circle, color: Colors.green, size: 10),
                                        const SizedBox(width: 8),
                                        Text(item.rating.toString().replaceAll('.', ','), style: const TextStyle(fontWeight: FontWeight.w700)),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.star, color: Colors.orange, size: 18),
                                        const SizedBox(width: 10),
                                        Text('₹${item.price}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
                                      ]),
                                    ]),
                                  ),

                                  const SizedBox(width: 12),
                         
                                  _addButton(item),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 20.0), child: Divider(thickness: 0.5)),
                          ],
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                ),

        
                SliverToBoxAdapter(child: const SizedBox(height: 100)),
              ],
            ),

         
            if (totalItems > 0)
              Positioned(
                left: 40,
                right: 40,
                bottom: 18,
                child: GestureDetector(
                  onTap: _openCartSheet,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(color: const Color(0xFFFB6B1A), borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4))]),
                    child: Center(
                      child: Text('View Cart ($totalItems items) • ₹$totalPrice', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
