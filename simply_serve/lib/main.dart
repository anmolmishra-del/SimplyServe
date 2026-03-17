import 'package:flutter/material.dart';
import 'package:simply_serve/features/home/presentation/home_screen.dart';
import 'package:simply_serve/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.teaHome,
      routes: {AppRoutes.teaHome: (context) => TeaHomeScreen()},
    );
  }
}
