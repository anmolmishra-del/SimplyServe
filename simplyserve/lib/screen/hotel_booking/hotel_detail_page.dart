// lib/pages/hotel_detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/custom_widget/custom_cached_image.dart';

class HotelDetailPage extends StatefulWidget {
  const HotelDetailPage({Key? key}) : super(key: key);

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  static const _mainImage =
      'https://media.cnn.com/api/v1/images/stellar/prod/140127103345-peninsula-shanghai-deluxe-mock-up.jpg?q=w_2226,h_1449,x_0,y_0,c_fill';
  static const _thumb1 = 'https://i.ytimg.com/vi/09pDca1mITM/sddefault.jpg';
  static const _thumb2 =
      'https://i0.wp.com/theluxurytravelexpert.com/wp-content/uploads/2019/08/LONDON-BEST-LUXURY-HOTELS-2-1.jpg?fit=1300%2C731&ssl=1';

  // booking state
  DateTimeRange? _selectedRange;
  int _rooms = 1;
  int _guests = 2;

  final DateFormat _dateFmtShort = DateFormat('MMM d');

  // helpers
  String get _checkInText => _selectedRange == null
      ? 'Mar 23'
      : _dateFmtShort.format(_selectedRange!.start);
  String get _checkOutText => _selectedRange == null
      ? '1 Room, 2 Guests'
      : _dateFmtShort.format(_selectedRange!.end);

  // ----- UI actions -----
  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final firstDate = now;
    final lastDate = now.add(const Duration(days: 365));
    final picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange:
          _selectedRange ??
          DateTimeRange(start: now, end: now.add(const Duration(days: 1))),
      helpText: 'Select check-in & check-out',
      confirmText: 'Apply',
    );

    if (picked != null) {
      setState(() => _selectedRange = picked);
    }
  }

  Future<void> _editRoomsGuests() async {
    int tempRooms = _rooms;
    int tempGuests = _guests;

    await showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (c) {
        return StatefulBuilder(
          builder: (context, innerSetState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Rooms & Guests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 14),

                  // Rooms row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rooms',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (tempRooms > 1) {
                                innerSetState(() => tempRooms--);
                              }
                            },
                          ),
                          Text(
                            '$tempRooms',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => innerSetState(() => tempRooms++),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Guests row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Guests',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (tempGuests > 1)
                                innerSetState(() => tempGuests--);
                            },
                          ),
                          Text(
                            '$tempGuests',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => innerSetState(() => tempGuests++),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary, // text color
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ), // border color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Save into parent state
                            setState(() {
                              _rooms = tempRooms;
                              _guests = tempGuests;
                            });
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _ratingChip(BuildContext c) {
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.primary, size: 18),
        const SizedBox(width: 6),
        const Text('4.6', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(width: 12),
        const Icon(Icons.location_on, size: 18, color: Colors.black54),
        const SizedBox(width: 6),
        const Text('Hyderabad', style: TextStyle(color: Colors.black54)),
        const SizedBox(width: 12),
        const Text('• Mar 22', style: TextStyle(color: Colors.black54)),
      ],
    );
  }

  Widget _gallery(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CustomCachedImage(
              imageUrl: _mainImage,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomCachedImage(
                  imageUrl: _thumb1,
                  height: 76,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomCachedImage(
                  imageUrl: _thumb2,
                  height: 76,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _roomCard(String title, String priceText) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              priceText,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '• Breakfast included',
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 4),
                Text(
                  '• Free cancellation',
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 4),
                Text('• Free Wi-Fi', style: TextStyle(color: Colors.black87)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _amenity(String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  String _roomsGuestsText() {
    return '$_rooms Room${_rooms > 1 ? 's' : ''}, $_guests Guest${_guests > 1 ? 's' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    // for date formatting, fallback if intl not added
    String formatShort(DateTime d) {
      try {
        return _dateFmtShort.format(d);
      } catch (_) {
        return '${d.month}/${d.day}';
      }
    }

    final checkInLabel = _selectedRange == null
        ? 'Mar 23'
        : formatShort(_selectedRange!.start);
    final checkOutLabel = _selectedRange == null
        ? 'Mar 24'
        : formatShort(_selectedRange!.end);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // top row: back + title + badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Marriott',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '20% OFF',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // rating row
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: _ratingChip(context),
                  ),

                  const SizedBox(height: 14),

                  // gallery
                  _gallery(context),

                  const SizedBox(height: 18),

                  // room cards (two side-by-side)
                  Row(
                    children: [
                      _roomCard('King Room', '₹4,500 per night'),
                      _roomCard('Double Queen', '₹4,500 per night'),
                    ],
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Amenities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 20,
                    runSpacing: 12,
                    children: [
                      _amenity('Hotel bar', Icons.local_bar_outlined),
                      _amenity('Fitness center', Icons.fitness_center_outlined),
                      _amenity('Spa services', Icons.spa_outlined),
                      _amenity('Room service', Icons.room_service_outlined),
                      _amenity('Swimming pool', Icons.pool_outlined),
                      _amenity('Parking', Icons.local_parking_outlined),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // checkin / checkout / rooms & guests row
                  Row(
                    children: [
                      // Check-in card (tappable -> date range picker)
                      Expanded(
                        child: InkWell(
                          onTap: _pickDateRange,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F8F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Check-in',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  checkInLabel,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Rooms & Guests (tappable -> edit dialog)
                      Expanded(
                        child: InkWell(
                          onTap: _editRoomsGuests,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F8F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Guests',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _roomsGuestsText(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 140), // bottom spacing
                ],
              ),
            ),

            Positioned(
              left: 20,
              right: 20,
              bottom: 18,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // demo action
                    final dates = _selectedRange == null
                        ? 'Dates not selected'
                        : '${formatShort(_selectedRange!.start)} - ${formatShort(_selectedRange!.end)}';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Booked $_rooms x $_guests • $dates'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                    ),
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
