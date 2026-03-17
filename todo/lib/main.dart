import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provicedr.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: catches all uncaught errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = TaskProvider();
        provider.loadTasks(); // Initial load
        return provider;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do App',
        theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
        initialRoute: Routes.home,
        routes: Routes.routes,
      ),
    );
  }
}
