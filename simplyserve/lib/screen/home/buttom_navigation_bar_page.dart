// import 'package:flutter/material.dart';
// import 'package:simplyserve/const/colour.dart';
// import 'package:simplyserve/main.dart';
// import 'package:simplyserve/screen/home/home_page.dart';
// import 'package:simplyserve/screen/home/offer_page.dart';
// import 'package:simplyserve/screen/home/order_page.dart';
// import 'package:simplyserve/screen/home/profile_page.dart';

// class RootScaffold extends StatefulWidget {
//   const RootScaffold({super.key});

//   @override
//   State<RootScaffold> createState() => _RootScaffoldState();
// }

// class _RootScaffoldState extends State<RootScaffold> {
//   int _selectedIndex = 0;

//   // Pages used by bottom nav
//   static final List<Widget> _pages = <Widget>[
//     const HomePage(),    // index 0
//     const OrdersPage(),  // index 1
//     const OffersPage(),  // index 2
//     const ProfilePage(), // index 3
//   ];

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         backgroundColor: Colors.white,
//         elevation: 8,
//         selectedItemColor: AppColors.primary,
//         unselectedItemColor: const Color(0xFF9CA3AF),
//         showUnselectedLabels: true,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
//           BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: 'Offers'),
//           BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }

// lib/screen/home/root_scaffold_motion.dart
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionBadgeWidget.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:simplyserve/const/colour.dart';
import 'package:simplyserve/screen/home/home_page.dart';
import 'package:simplyserve/screen/home/order_page.dart';
import 'package:simplyserve/screen/home/offer_page.dart';
import 'package:simplyserve/screen/home/profile_page.dart';

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold>
    with TickerProviderStateMixin {
  late MotionTabBarController _motionController;

  final List<Widget> _pages = const [
    HomePage(),
    OrdersPage(),
    OffersPage(),
    ProfilePage(),
  ];

  // If you have a cart count or notifications, update this value
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();

    _motionController = MotionTabBarController(
      initialIndex: 0,
      length: _pages.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _motionController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _motionController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),

      bottomNavigationBar: MotionTabBar(
        controller: _motionController,
        initialSelectedTab: "Home",
        useSafeArea: true,
        labels: const ["Home", "Orders", "Offers", "Profile"],
        icons: const [
          Icons.home,
          Icons.receipt_long,
          Icons.local_offer_outlined,
          Icons.person_outline,
        ],

        badges: [
          null,

          _cartCount > 0
              ? MotionBadgeWidget(
                  text: _cartCount > 99 ? '99+' : '$_cartCount',
                  textColor: Colors.white,
                  color: Colors.red,
                  size: 18,
                )
              : null,

          const MotionBadgeWidget(
            text: 'NEW',
            textColor: Colors.white,
            color: Colors.green,
            size: 16,
          ),

          const MotionBadgeWidget(
            isIndicator: true,
            show: true,
            color: Colors.red,
            size: 6,
          ),
        ],

        tabSize: 50,
        tabBarHeight: 60,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        tabIconColor: Colors.grey,
        tabIconSize: 26.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: AppColors.gradientColour,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int index) {
          _onTabSelected(index);
        },
      ),
    );
  }
}
