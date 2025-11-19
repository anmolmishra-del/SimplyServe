// lib/travel/flight_search.dart
import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';

class FlightSearchPage extends StatefulWidget {
  const FlightSearchPage({Key? key}) : super(key: key);

  @override
  State<FlightSearchPage> createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  final TextEditingController _originCtrl = TextEditingController(text: 'BLR');
  final TextEditingController _destCtrl = TextEditingController(text: 'DEL');
  DateTime? _travelDate;
  int _passengers = 1;
  bool _isSearching = false;

  List<_FlightResult> _results = [];

  @override
  void dispose() {
    _originCtrl.dispose();
    _destCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _travelDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _travelDate = picked);
  }

  void _changePassengers(int delta) {
    setState(() {
      _passengers = (_passengers + delta).clamp(1, 9);
    });
  }

  Future<void> _doSearch() async {
    if (_originCtrl.text.trim().isEmpty || _destCtrl.text.trim().isEmpty || _travelDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill origin, destination and date')));
      return;
    }

    setState(() {
      _isSearching = true;
      _results = [];
    });

    // simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // sample data (replace with API)
    final sample = <_FlightResult>[
      _FlightResult(airline: 'Air India', flightNo: 'AI-123', departTime: '07:25', arriveTime: '09:40', duration: '2h 15m', price: 4999, stops: 0),
      _FlightResult(airline: 'IndiGo', flightNo: '6E-456', departTime: '10:10', arriveTime: '12:35', duration: '2h 25m', price: 4599, stops: 0),
      _FlightResult(airline: 'SpiceJet', flightNo: 'SG-789', departTime: '17:00', arriveTime: '19:30', duration: '2h 30m', price: 3999, stops: 1),
    ];

    setState(() {
      _isSearching = false;
      _results = sample;
    });
  }

  String get _dateLabel {
    if (_travelDate == null) return 'Select date';
    final d = _travelDate!;
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Flights', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))],
                ),
                child: Column(
                  children: [
                    // Origin & Destination
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Origin', _originCtrl)),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 36,
                          child: Center(child: Icon(Icons.swap_horiz, color: AppColors.grey)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField('Destination', _destCtrl)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Date & Passengers row
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(color: const Color(0xFFF7F7F8), borderRadius: BorderRadius.circular(8)),
                              child: Row(children: [
                                const Icon(Icons.calendar_today, size: 18, color: AppColors.grey),
                                const SizedBox(width: 8),
                                Text(_dateLabel, style: const TextStyle(color: AppColors.textDark)),
                              ]),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFFF7F7F8), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              IconButton(onPressed: () => _changePassengers(-1), icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary), splashRadius: 18),
                              Text('$_passengers', style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(onPressed: () => _changePassengers(1), icon: const Icon(Icons.add_circle_outline, color: AppColors.primary), splashRadius: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Search Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSearching ? null : _doSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isSearching ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Search Flights', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filters row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(children: [
                _filterChip(icon: Icons.sort, label: 'Sort'),
                const SizedBox(width: 8),
                _filterChip(icon: Icons.swap_calls, label: 'Stops'),
                const SizedBox(width: 8),
                _filterChip(icon: Icons.tune, label: 'Price'),
                const SizedBox(width: 8),
                const Spacer(),
                Text('${_results.length} results', style: const TextStyle(color: AppColors.grey)),
              ]),
            ),
            const SizedBox(height: 10),

            // Results area
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? Center(child: Text('No results yet. Try searching above.', style: TextStyle(color: AppColors.grey)))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemBuilder: (ctx, i) => _flightResultCard(_results[i]),
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemCount: _results.length,
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: const Color(0xFFF7F7F8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _filterChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)]),
      child: Row(children: [Icon(icon, size: 16, color: AppColors.primary), const SizedBox(width: 6), Text(label, style: const TextStyle(fontWeight: FontWeight.w600))]),
    );
  }

  Widget _flightResultCard(_FlightResult f) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          // Airline badge
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(_airlineInitials(f.airline), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))),
          ),
          const SizedBox(width: 12),

          // Time & details
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(f.departTime, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.flight_land, size: 12, color: AppColors.grey),
                const SizedBox(width: 8),
                Text(f.arriveTime, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 6),
              Text('${f.airline} • ${f.flightNo} • ${f.duration} • ${f.stops == 0 ? "Nonstop" : "${f.stops} stop(s)"}', style: const TextStyle(color: AppColors.grey)),
            ]),
          ),

          // Price & Book
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('₹${f.price}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking flow not implemented (placeholder)')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Book', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ]),
        ],
      ),
    );
  }

  String _airlineInitials(String airline) {
    final parts = airline.split(' ');
    if (parts.isEmpty) return airline.substring(0, airline.length >= 2 ? 2 : 1).toUpperCase();
    return parts.map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase();
  }
}

class _FlightResult {
  final String airline;
  final String flightNo;
  final String departTime;
  final String arriveTime;
  final String duration;
  final int price;
  final int stops;
  _FlightResult({required this.airline, required this.flightNo, required this.departTime, required this.arriveTime, required this.duration, required this.price, required this.stops});
}
