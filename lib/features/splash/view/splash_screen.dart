// lib/features/splash/view/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:merchantside_app/core/storage/secure_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final token = await SecureStorageService.getToken();
    await Future.delayed(
      const Duration(seconds: 2),
    ); // show splash for 2 seconds
    if (token != null) {
      Navigator.pushReplacementNamed(context, '/merchanthome');
    } else {
      Navigator.pushReplacementNamed(context, '/merchantlogin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/Logo.png',
          width: size.width * 0.5,
          height: size.width * 0.5,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
