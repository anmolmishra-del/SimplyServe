
import 'package:flutter/material.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: const Center(child: Text('Offers page content goes here')),
    );
  }
}
