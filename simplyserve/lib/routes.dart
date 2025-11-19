import 'package:flutter/material.dart';
import 'package:simplyserve/screen/onbording_page/onbording_page.dart';
import 'package:simplyserve/screen/landing_page/landing_page.dart';
import 'package:simplyserve/screen/landing_page/login.dart';
import 'package:simplyserve/screen/landing_page/signup_page.dart';
import 'package:simplyserve/screen/home/buttom_navigation_bar_page.dart';
import 'package:simplyserve/screen/location/change_location_page.dart';
import 'package:simplyserve/screen/notifications/notifications_page.dart';
import 'package:simplyserve/screen/food_order/order_food_page.dart';
import 'package:simplyserve/screen/groceries/groceries_page.dart';
import 'package:simplyserve/screen/hotel_booking/hotels_booking_page.dart';
import 'package:simplyserve/screen/hotel_booking/hotel_detail_page.dart';
import 'package:simplyserve/screen/food_order/order_detail_page.dart';


class Routes {
  Routes._();

  static const String onboarding = '/onboarding';
  static const String loginLanding = '/login_landing';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String changeLocation = '/change-location';
  static const String notifications = '/notifications';
  static const String orderFood = '/order-food';
  static const String groceries = '/groceries';
  static const String hotels = '/hotels';
  static const String hotelDetail = '/hotel-detail';
  static const String restaurantDetail = '/restaurant-detail';

  static Map<String, WidgetBuilder> getAll() {
    return {
      onboarding: (c) => const OnbordingPage(),
      loginLanding: (c) => const LoginLandingPage(),
      login: (c) => const LoginPage(),
      signup: (c) => const SignupPage(),
      home: (c) => const RootScaffold(),
      changeLocation: (c) => const ChangeLocationPage(),
      notifications: (c) => const NotificationsPage(),
      orderFood: (c) => const OrderFoodPage(),
      groceries: (c) => const GroceriesPage(),
      hotels: (c) => const HotelsBookingPage(),
      hotelDetail: (c) => const HotelDetailPage(),
      restaurantDetail: (c) => const RestaurantDetailPageUiMatch(),
    };
  }
}
