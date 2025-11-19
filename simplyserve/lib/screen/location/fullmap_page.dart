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
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  String _address = "Fetching address...";
  double _currentLat = 0;
  double _currentLng = 0;
  bool _isLocationInitialized = false;

  // Search related variables
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;
  String _searchError = '';

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus && _searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
        _searchError = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSearchResults = true;
      _searchError = '';
    });

    try {
      // Use OpenStreetMap Nominatim API (free, no API key required)
      await _performNominatimSearch(query);
    } catch (e) {
      print('Search error: $e');
      setState(() {
        _searchError = 'Search failed. Please try again.';
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _performNominatimSearch(String query) async {
    String encodedQuery = Uri.encodeComponent(query);

    // OpenStreetMap Nominatim API - free and no API key required
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?format=json&q=$encodedQuery&limit=10&countrycodes=in&addressdetails=1',
    );

    print('🔍 Searching: $query');
    print('📡 URL: $url');

    final response = await http
        .get(
          url,
          headers: {
            'User-Agent': 'SimplyServeApp/1.0 (your-email@example.com)',
          },
        )
        .timeout(Duration(seconds: 10));

    print('📥 Response Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('📊 Results found: ${data.length}');

      if (data.isNotEmpty) {
        setState(() {
          _searchResults = data;
          _searchError = '';
        });
        print('✅ Search successful: ${_searchResults.length} results');
      } else {
        setState(() {
          _searchResults = [];
          _searchError = 'No locations found for "$query"';
        });
        print('❌ No results found');
      }
    } else {
      throw Exception('API error: ${response.statusCode}');
    }
  }

  void _onLocationSelected(Map<String, dynamic> feature) {
    try {
      final double lat = double.parse(feature['lat'].toString());
      final double lng = double.parse(feature['lon'].toString());
      final String displayName = feature['display_name'] ?? 'Selected Location';
      final String name =
          feature['name'] ?? feature['display_name'] ?? 'Location';

      print('📍 Selected: $name at $lat, $lng');

      // Move map to selected location
      _map?.flyTo(
        CameraOptions(
          center: Point(coordinates: mapbox.Position(lng, lat)),
          zoom: 16,
        ),
        MapAnimationOptions(duration: 1000, startDelay: 0),
      );

      // Update current location and address
      setState(() {
        _currentLat = lat;
        _currentLng = lng;
        _address = _cleanAddress(displayName);
        _showSearchResults = false;
      });

      // Clear search
      _searchController.clear();
      _searchFocusNode.unfocus();
    } catch (e) {
      print('Error selecting location: $e');
      setState(() {
        _searchError = 'Error selecting location. Please try again.';
      });
    }
  }

  String _cleanAddress(String address) {
    // Clean up the address by removing redundant parts
    List<String> parts = address.split(',');
    if (parts.length > 3) {
      // Take first 3 parts for cleaner display
      return parts.sublist(0, 3).join(', ').trim();
    }
    return address;
  }

  String _getLocationTitle(Map<String, dynamic> feature) {
    return feature['name']?.toString() ??
        feature['display_name']?.split(',').first ??
        'Unknown Location';
  }

  String _getLocationSubtitle(Map<String, dynamic> feature) {
    final displayName = feature['display_name'] ?? '';
    if (displayName.isNotEmpty) {
      // Remove the first part (name) if it's duplicated
      String title = _getLocationTitle(feature);
      if (displayName.startsWith('$title, ')) {
        return displayName.substring(title.length + 2);
      }

      // Limit to reasonable length
      if (displayName.length > 60) {
        List<String> parts = displayName.split(',');
        if (parts.length > 2) {
          return parts
              .sublist(1, parts.length > 3 ? 4 : parts.length)
              .join(', ');
        }
      }

      return displayName;
    }
    return 'Location details';
  }

  Widget _buildSearchResults() {
    if (!_showSearchResults) {
      return SizedBox.shrink();
    }

    return Positioned(
      top: 80,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          constraints: BoxConstraints(maxHeight: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Your Location",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (_searchController.text.isNotEmpty)
                      Text(
                        '"${_searchController.text}"',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey[300]),
                    SizedBox(height: 8),
                    Text(
                      "SEARCH RESULTS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              // Error message
              if (_searchError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.orange, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _searchError,
                          style: TextStyle(color: Colors.orange, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              // Results list
              Expanded(
                child: _isSearching
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.orange,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Searching for "${_searchController.text}"...',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _searchResults.isEmpty
                    ? Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No locations found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try searching for:',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Hyderabad, Mumbai, Delhi, Bangalore',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 16),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final feature = _searchResults[index];
                          final title = _getLocationTitle(feature);
                          final subtitle = _getLocationSubtitle(feature);

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _onLocationSelected(feature),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: index < _searchResults.length - 1
                                        ? BorderSide(color: Colors.grey[200]!)
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            subtitle,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                              height: 1.3,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Test search function
  void _testSearch() {
    print('🧪 Testing search functionality...');
    _performSearch('Hyderabad');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Test search when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🚀 FullMapPage initialized - testing search...');
    });
  }

  Future<void> _initializeLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _address = "Location services are disabled");
        return;
      }

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

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLat = position.latitude;
        _currentLng = position.longitude;
        _isLocationInitialized = true;
      });

      await _getHumanReadableAddress(_currentLat, _currentLng);

      _map?.flyTo(
        CameraOptions(
          center: Point(coordinates: mapbox.Position(_currentLng, _currentLat)),
          zoom: 16,
        ),
        MapAnimationOptions(duration: 1000, startDelay: 0),
      );
    } catch (e) {
      print('Location error: $e');
      setState(() => _address = "Unable to fetch location");
    }
  }

  Future<void> _getHumanReadableAddress(double lat, double lng) async {
    try {
      // Use OpenStreetMap reverse geocoding
      String osmAddress = await _getAddressFromOSM(lat, lng);
      if (osmAddress.isNotEmpty && osmAddress != "Unknown location") {
        setState(() {
          _address = osmAddress;
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

  Future<String> _getAddressFromOSM(double lat, double lng) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1',
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'SimplyServeApp/1.0 (your-email@example.com)'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? "Unknown location";
      }
    } catch (e) {
      print('OSM API error: $e');
    }
    return "Unknown location";
  }

  String _extractReadableAddress(List<Placemark> placemarks) {
    for (Placemark place in placemarks) {
      if (place.locality != null &&
          place.locality!.isNotEmpty &&
          place.subLocality != null &&
          place.subLocality!.isNotEmpty) {
        return "${place.locality!.trim()}, ${place.subLocality!.trim()}";
      }

      if (place.street != null &&
          place.street!.isNotEmpty &&
          place.locality != null &&
          place.locality!.isNotEmpty) {
        if (!_isTechnicalAddress(place.street!)) {
          return "${place.street!.trim()}, ${place.locality!.trim()}";
        }
      }

      if (place.locality != null && place.locality!.isNotEmpty) {
        return place.locality!.trim();
      }

      if (place.subLocality != null && place.subLocality!.isNotEmpty) {
        return place.subLocality!.trim();
      }

      if (place.name != null &&
          place.name!.isNotEmpty &&
          !_isTechnicalAddress(place.name!)) {
        return place.name!.trim();
      }
    }

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

    if (place.name != null &&
        place.name!.isNotEmpty &&
        !_isTechnicalAddress(place.name!)) {
      parts.add(place.name!);
    }

    if (place.street != null &&
        place.street!.isNotEmpty &&
        !_isTechnicalAddress(place.street!)) {
      parts.add(place.street!);
    }

    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      parts.add(place.subLocality!);
    }

    if (place.locality != null && place.locality!.isNotEmpty) {
      parts.add(place.locality!);
    }

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
    _searchController.dispose();
    _searchFocusNode.dispose();
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
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _searchFocusNode.requestFocus();
              if (_searchController.text.isEmpty) {
                _performSearch('Hyderabad');
              }
            },
            tooltip: 'Test Search',
          ),
        ],
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
              child: GestureDetector(
                onTap: () {
                  _searchFocusNode.requestFocus();
                },
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
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          decoration: InputDecoration(
                            hintText: "Search Hyderabad, Mumbai, Delhi...",
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onChanged: _performSearch,
                          onTap: () {
                            if (_searchController.text.isNotEmpty) {
                              _performSearch(_searchController.text);
                            }
                          },
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.close, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _showSearchResults = false;
                              _searchResults = [];
                              _searchError = '';
                            });
                            _searchFocusNode.unfocus();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Search results
            _buildSearchResults(),

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
