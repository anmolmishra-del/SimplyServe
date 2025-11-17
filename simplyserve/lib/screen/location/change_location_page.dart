import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Position;
import 'package:simplyserve/const/colour.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:simplyserve/screen/location/fullmap_page.dart';

class ChangeLocationPage extends StatefulWidget {
  const ChangeLocationPage({super.key});

  @override
  State<ChangeLocationPage> createState() => _ChangeLocationPageState();
}

class _ChangeLocationPageState extends State<ChangeLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  MapboxMap? _mapController;

  final List<Map<String, String>> _savedLocations = [
    {'label': 'Home', 'subtitle': 'Hyderabad, India'},
    {'label': 'Work', 'subtitle': 'Hitech City'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _useCurrentLocation() async {
    try {
      // Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              FullMapPage(lat: position.latitude, lng: position.longitude),
        ),
      );
      // Convert coordinates to city name
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String city = placemarks[0].locality ?? 'Unknown location';

      // Show the city name
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('You are in $city')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
    }

    // TODO: wire location permission + actual location fetching
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Using current location (demo)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFFF7A2D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: back arrow
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Title
              const Text(
                'Change Location',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 18),

              // Search field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: Colors.black54),
                    hintText: 'Search for your location',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Map placeholder card with rounded corners and pin
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF6EF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF0F0F0)),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: MapWidget(
                            styleUri: MapboxStyles.MAPBOX_STREETS, // add style
                            // resourceOptions: ResourceOptions(
                            //   accessToken: dotenv.env["MAPBOX_ACCESS_TOKEN"],
                            // ),
                            cameraOptions: CameraOptions(
                              center: Point(
                                coordinates: mapbox.Position(78.4867, 17.3850),
                                // lng, lat
                              ),
                              zoom: 14,
                            ),
                            onMapCreated: (map) {
                              map.location.updateSettings(
                                LocationComponentSettings(
                                  enabled: false,
                                  pulsingEnabled: true,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Large orange button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _useCurrentLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Use My Current Location',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Divider(height: 8, thickness: 1, color: Color(0xFFF2F2F2)),

              // Saved locations list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 12, bottom: 24),
                  itemCount:
                      _savedLocations.length + 1, // +1 for Add New Location row
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFFF2F2F2)),
                  itemBuilder: (context, index) {
                    if (index < _savedLocations.length) {
                      final loc = _savedLocations[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 12,
                        ),
                        title: Text(
                          loc['label']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            loc['subtitle']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.black54,
                        ),
                        onTap: () {
                          // TODO: select this saved location
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selected: ${loc['label']}'),
                            ),
                          );
                        },
                      );
                    } else {
                      // Add New Location row
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 12,
                        ),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 22),
                        ),
                        title: const Text(
                          'Add New Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () {
                          // TODO: open add location screen / flow
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Add new location tapped'),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
