import 'package:flutter/material.dart';
import 'package:simplyserve/custom_widget/custom_textfromfiled.dart';

class LocationDetailsScreen extends StatefulWidget {
  final double lat;
  final double lng;
  final String address;

  const LocationDetailsScreen({
    super.key,
    required this.lat,
    required this.lng,
    required this.address,
  });

  @override
  State<LocationDetailsScreen> createState() => _LocationDetailsScreenState();
}

class _LocationDetailsScreenState extends State<LocationDetailsScreen> {
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _saveAsController = TextEditingController();

  String _selectedSaveAs = 'Home';
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    // Pre-fill apartment field with the address from map
    _apartmentController.text = widget.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Add Delivery Location",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Header Card
            _buildLocationHeader(),
            const SizedBox(height: 15),

            // Delivery instruction
            _buildDeliveryInstruction(),
            const SizedBox(height: 15),

            // Form Fields
            _buildHouseFlatNo(),
            const SizedBox(height: 10),

            _buildApartmentRoadArea(),
            const SizedBox(height: 10),

            _buildDirections(),
            const SizedBox(height: 10),

            // Voice directions
            _buildVoiceDirections(),
            const SizedBox(height: 10),

            // Save as section
            _buildSaveAsSection(),
            const SizedBox(height: 10),

            // Save Button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            widget.address.length > 60
                ? '${widget.address.substring(0, 60)}...'
                : widget.address,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Coordinates: ${widget.lat.toStringAsFixed(6)}, ${widget.lng.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInstruction() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "your doorstep easily",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Add details to help our delivery partner reach you faster",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildHouseFlatNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "HOUSE / FLAT / BLOCK NO.",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          hint: 'ENTER HOUSE / FLAT / BLOCK NO.',
          controller: _houseNoController,
        ),
      ],
    );
  }

  Widget _buildApartmentRoadArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              "APARTMENT / ROAD / AREA",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 4),
            Text(
              "(RECOMMENDED)",
              style: TextStyle(fontSize: 10, color: Colors.orange),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomTextField(
          hint: 'Enter apartment, road or area name',
          controller: _apartmentController,
        ),
      ],
    );
  }

  Widget _buildDirections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "DIRECTIONS TO REACH (OPTIONAL)",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          hint: 'e.g., Near metro station, behind building, etc.',
          controller: _directionsController,
        ),
      ],
    );
  }

  Widget _buildVoiceDirections() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.mic_none, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text(
                "Tap to record voice directions",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "e.g. Ring the bell on the red gate",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  "0/200",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveAsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "save as",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // Save as options
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSaveAsOption('Home', Icons.home_outlined),
            _buildSaveAsOption('Work', Icons.work_outline),
            _buildSaveAsOption('Friends and Family', Icons.people_outline),
            _buildSaveAsOption('Other', Icons.category_outlined),
          ],
        ),

        const SizedBox(height: 16),

        // Custom name input (shown when Other is selected)
        if (_selectedSaveAs == 'Other')
          CustomTextField(
            hint: 'Enter custom name',
            controller: _saveAsController,
          ),
      ],
    );
  }

  Widget _buildSaveAsOption(String title, IconData icon) {
    bool isSelected = _selectedSaveAs == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSaveAs = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
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
          // Save the location details
          _saveLocationDetails();
        },
        child: const Text(
          "Save Delivery Location",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _saveLocationDetails() {
    final locationData = {
      'lat': widget.lat,
      'lng': widget.lng,
      'mainAddress': widget.address,
      'houseNo': _houseNoController.text,
      'apartmentRoadArea': _apartmentController.text,
      'directions': _directionsController.text,
      'saveAs': _selectedSaveAs == 'Other'
          ? _saveAsController.text
          : _selectedSaveAs,
      'fullAddress':
          '${_houseNoController.text.isNotEmpty ? '${_houseNoController.text}, ' : ''}${_apartmentController.text}',
    };

    // Print or save the data
    print('Saved Location: $locationData');

    // Show success message and go back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Delivery location saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back to previous screen
    Navigator.pop(context, locationData);
  }

  @override
  void dispose() {
    _houseNoController.dispose();
    _apartmentController.dispose();
    _directionsController.dispose();
    _saveAsController.dispose();
    super.dispose();
  }
}
