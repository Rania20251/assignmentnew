import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SmartClinicApp());
}

class SmartClinicApp extends StatelessWidget {
  const SmartClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedLink',
      home: SplashScreen(),
    );
  }
}