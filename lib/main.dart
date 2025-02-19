import 'package:flutter/material.dart';
import 'HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      title: 'LaptopHarbor',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set your primary theme color
      ),
      home: HomePage(),
    );
  }
}
