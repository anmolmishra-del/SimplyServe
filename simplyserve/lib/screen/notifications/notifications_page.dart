import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {

  final Widget? fallbackPage;

  const NotificationsPage({super.key, this.fallbackPage});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  final List<_NotifItem> _items = [
    _NotifItem(
      id: '1',
      title: 'Your food order is being prepared',
      subtitle: 'Meghana Foods · 5 min ago',
      isUnread: true,
      icon: Icons.ramen_dining,
    ),
    _NotifItem(
      id: '2',
      title: '20% off on your next grocery order!',
      subtitle: 'Instamart · 25 min ago',
      isUnread: true,
      icon: Icons.card_giftcard,
    ),
    _NotifItem(
      id: '3',
      title: 'Hotel booking confirmed at Marriott',
      subtitle: 'Yesterday',
      isUnread: false,
      icon: Icons.apartment,
    ),
    _NotifItem(
      id: '4',
      title: 'Your delivery from Meghana Foods is complete',
      subtitle: 'Apr 22',
      isUnread: false,
      icon: Icons.check_circle,
      iconColor: Colors.green,
    ),
    _NotifItem(
      id: '5',
      title: 'New offers have been added!',
      subtitle: 'Apr 20',
      isUnread: false,
      icon: Icons.card_giftcard,
    ),
    _NotifItem(
      id: '6',
      title: 'Your grocery order has been dispatched',
      subtitle: 'Apr 18',
      isUnread: false,
      icon: Icons.shopping_cart_outlined,
    ),
  ];

  void _safeBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else if (widget.fallbackPage != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.fallbackPage!),
      );
    } else {
      // No-op if there's nowhere to go. You could also pushReplacement to Home.
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in _items) {
        n.isUnread = false;
      }
    });
  }

  void _toggleRead(String id) {
    setState(() {
      final idx = _items.indexWhere((e) => e.id == id);
      if (idx != -1) _items[idx].isUnread = !_items[idx].isUnread;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFFFF0E6);
    final highlight = const Color(0xFFFFE9D6);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
          
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: _safeBack,
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _markAllAsRead,
                    child: const Text(
                      'Mark all as read',
                      style: TextStyle(color: Color(0xFFFF7A2D), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Content list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _items[index];

                  // Unread highlighted card style (rounded orange-tinge background)
                  if (item.isUnread) {
                    return GestureDetector(
                      onTap: () => _toggleRead(item.id),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: highlight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Leading icon with circular background
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: orange,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(item.icon, size: 28, color: item.iconColor ?? Colors.orange.shade900),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Texts
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.subtitle,
                                    style: TextStyle(color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Read/simple row style
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Center(
                        child: Icon(item.icon, size: 26, color: item.iconColor ?? Colors.orange),
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        item.subtitle,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    onTap: () => _toggleRead(item.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifItem {
  final String id;
  final String title;
  final String subtitle;
  bool isUnread;
  final IconData icon;
  final Color? iconColor;

  _NotifItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isUnread,
    required this.icon,
    this.iconColor,
  });
}
