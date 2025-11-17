import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Position;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:simplyserve/screen/location/location_details_screen.dart';

class FullMapPage extends StatefulWidget {
  final double lat;
  final double lng;

  const FullMapPage({super.key, required this.lat, required this.lng});

  @override
  State<FullMapPage> createState() => _FullMapPageState();
}

class _FullMapPageState extends State<FullMapPage> {
  MapboxMap? _map;
  Timer? _idleTimer;

  String _address = "Fetching address...";
  double _currentLat = 0;
  double _currentLng = 0;
  bool _isLocationInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _address = "Location services are disabled");
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _address = "Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _address = "Location permission permanently denied");
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLat = position.latitude;
        _currentLng = position.longitude;
        _isLocationInitialized = true;
      });

      await _getHumanReadableAddress(_currentLat, _currentLng);

      // Update map camera to current location
      _map?.flyTo(
        CameraOptions(
          center: Point(coordinates: mapbox.Position(_currentLng, _currentLat)),
          zoom: 16,
        ),
        MapAnimationOptions(duration: 1000, startDelay: 0),
      );
    } catch (e) {
      setState(() => _address = "Unable to fetch location");
    }
  }

  // Method 1: Use Mapbox Reverse Geocoding API for better human-readable addresses
  Future<void> _getHumanReadableAddress(double lat, double lng) async {
    try {
      // First try Mapbox API for better results
      String mapboxAddress = await _getAddressFromMapbox(lat, lng);
      if (mapboxAddress.isNotEmpty && mapboxAddress != "Unknown location") {
        setState(() {
          _address = mapboxAddress;
        });
        return;
      }

      // Fallback to device geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        String readableAddress = _extractReadableAddress(placemarks);
        setState(() {
          _address = readableAddress;
        });
      } else {
        setState(() => _address = "Location details not available");
      }
    } catch (e) {
      print('Address fetching error: $e');
      setState(() => _address = "Fetching location...");
    }
  }

  // Mapbox Reverse Geocoding - gives much better human-readable results
  Future<String> _getAddressFromMapbox(double lat, double lng) async {
    const String accessToken =
        'YOUR_MAPBOX_ACCESS_TOKEN'; // Replace with your token
    final url = Uri.parse(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?access_token=$accessToken&types=poi,address,neighborhood,locality,place&limit=1',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null && data['features'].isNotEmpty) {
          String placeName = data['features'][0]['place_name'] ?? '';

          // Clean up the address - remove country if it's too long
          if (placeName.contains(',')) {
            List<String> parts = placeName.split(',');
            // Take only first 2-3 parts (street, area, city) - remove country
            if (parts.length > 2) {
              return parts.sublist(0, 2).join(', ').trim();
            }
            return placeName;
          }
          return placeName;
        }
      }
    } catch (e) {
      print('Mapbox API error: $e');
    }
    return "Unknown location";
  }

  // Extract human-readable address from placemarks
  String _extractReadableAddress(List<Placemark> placemarks) {
    for (Placemark place in placemarks) {
      // Look for the most human-readable combination

      // Case 1: Locality + SubLocality (Most common for colonies/areas)
      if (place.locality != null &&
          place.locality!.isNotEmpty &&
          place.subLocality != null &&
          place.subLocality!.isNotEmpty) {
        return "${place.locality!.trim()}, ${place.subLocality!.trim()}";
      }

      // Case 2: Street + Locality
      if (place.street != null &&
          place.street!.isNotEmpty &&
          place.locality != null &&
          place.locality!.isNotEmpty) {
        // Skip if street is just a number or contains "Plot", "Survey"
        if (!_isTechnicalAddress(place.street!)) {
          return "${place.street!.trim()}, ${place.locality!.trim()}";
        }
      }

      // Case 3: Just the locality name (like "Friends Colony")
      if (place.locality != null && place.locality!.isNotEmpty) {
        return place.locality!.trim();
      }

      // Case 4: SubLocality name
      if (place.subLocality != null && place.subLocality!.isNotEmpty) {
        return place.subLocality!.trim();
      }

      // Case 5: Name field if it's meaningful
      if (place.name != null &&
          place.name!.isNotEmpty &&
          !_isTechnicalAddress(place.name!)) {
        return place.name!.trim();
      }
    }

    // Fallback: Use the first placemark with filtering
    Placemark place = placemarks.first;
    return _formatForDisplay(place);
  }

  bool _isTechnicalAddress(String text) {
    List<String> technicalKeywords = [
      'plot',
      'survey',
      'no.',
      'number',
      'gata',
      'khanda',
      'ward',
    ];
    String lowerText = text.toLowerCase();
    return technicalKeywords.any((keyword) => lowerText.contains(keyword));
  }

  String _formatForDisplay(Placemark place) {
    List<String> parts = [];

    // Add name if it's not technical
    if (place.name != null &&
        place.name!.isNotEmpty &&
        !_isTechnicalAddress(place.name!)) {
      parts.add(place.name!);
    }

    // Add street if available and not technical
    if (place.street != null &&
        place.street!.isNotEmpty &&
        !_isTechnicalAddress(place.street!)) {
      parts.add(place.street!);
    }

    // Add subLocality
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      parts.add(place.subLocality!);
    }

    // Add locality
    if (place.locality != null && place.locality!.isNotEmpty) {
      parts.add(place.locality!);
    }

    // Remove duplicates and empty parts
    parts = parts.where((part) => part.trim().isNotEmpty).toSet().toList();

    if (parts.isEmpty) {
      return "Current location";
    }

    return parts.join(', ');
  }

  void _onCameraChanged(dynamic data) {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(milliseconds: 500), () {
      try {
        final center = data.center;
        final lat = center.latitude as double;
        final lng = center.longitude as double;

        setState(() {
          _currentLat = lat;
          _currentLng = lng;
        });
        _getHumanReadableAddress(lat, lng);
      } catch (e) {
        print('Error parsing camera data: $e');
      }
    });
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: NotificationListener<Notification>(
        onNotification: (notification) {
          final runtimeType = notification.runtimeType.toString();
          if (runtimeType.contains('CameraChanged')) {
            try {
              final data = (notification as dynamic).data;
              _onCameraChanged(data);
            } catch (e) {
              print('Error handling camera notification: $e');
            }
          }
          return true;
        },
        child: Stack(
          children: [
            MapWidget(
              cameraOptions: CameraOptions(
                center: Point(
                  coordinates: mapbox.Position(
                    _isLocationInitialized ? _currentLng : widget.lng,
                    _isLocationInitialized ? _currentLat : widget.lat,
                  ),
                ),
                zoom: 16,
              ),
              styleUri: MapboxStyles.MAPBOX_STREETS,
              onMapCreated: (map) {
                _map = map;

                map.location.updateSettings(
                  LocationComponentSettings(
                    enabled: true,
                    pulsingEnabled: true,
                    pulsingColor: Colors.blue.value,
                  ),
                );

                try {
                  (map as dynamic).subscribeCameraChanged(_onCameraChanged);
                } catch (e) {
                  print('subscribeCameraChanged not available: $e');
                }

                if (!_isLocationInitialized) {
                  _initializeLocation();
                }
              },
            ),

            // Center pin
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_pin, color: Colors.red, size: 40),
                  SizedBox(height: 40),
                ],
              ),
            ),

            // Search bar
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Search an area or address",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Current location button
            Positioned(
              right: 16,
              bottom: 180,
              child: FloatingActionButton(
                onPressed: _initializeLocation,
                backgroundColor: Colors.white,
                child: const Icon(Icons.my_location, color: Colors.black),
              ),
            ),

            // Bottom address sheet
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Place the pin at exact delivery location",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _address,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationDetailsScreen(
                                  lat: _currentLat,
                                  lng: _currentLng,
                                  address: _address,
                                ),
                              ),
                            );
                          },

                          child: const Text(
                            "Confirm & proceed",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
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
