import 'package:flutter/material.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/main.dart';
import 'package:simplyserve/screen/home/home_page.dart';
import 'package:simplyserve/screen/home/offer_page.dart';
import 'package:simplyserve/screen/home/order_page.dart';
import 'package:simplyserve/screen/home/profile_page.dart';

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _selectedIndex = 0;

  // Pages used by bottom nav
  static final List<Widget> _pages = <Widget>[
    const HomePage(),    // index 0
    const OrdersPage(),  // index 1
    const OffersPage(),  // index 2
    const ProfilePage(), // index 3
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF9CA3AF),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: 'Offers'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}