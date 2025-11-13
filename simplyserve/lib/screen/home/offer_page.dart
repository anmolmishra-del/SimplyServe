import 'package:flutter/material.dart';
import 'package:simplyserve/const/image.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  final List<Map<String, String>> _offers = const [
    {
      'title': 'Get 20% off on groceries this week',
      'subtitle': 'Save on your grocery purchase',
      // you can replace these with asset names if you have real images
      'icon': 'bag',
    },
    {
      'title': 'Free delivery on first food order',
      'subtitle': 'Enjoy no delivery charge on your first order',
      'icon': 'cloche',
    },
    {
      'title': 'Discounts at top hotels',
      'subtitle': 'Great deals at highly rated hotels',
      'icon': 'tag',
    },
  ];

  Widget _iconFor(String key) {
    switch (key) {
      case 'bag':
        return Image.asset(AppImage.offers1);
      case 'cloche':
        return Image.asset(AppImage.offers2);
      case 'tag':
        return Image.asset(AppImage.offers3);
      default:
        return const Icon(
          Icons.local_offer_rounded,
          size: 28,
          color: Colors.orange,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                'Offers',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                itemCount: _offers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final offer = _offers[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 68,
                        height: 68,

                        child: Center(child: _iconFor(offer['icon']!)),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer['title']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              offer['subtitle']!,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
