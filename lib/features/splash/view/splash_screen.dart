// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class MerchantSplashScreen extends StatelessWidget {
  const MerchantSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to UserHome after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/merchanthome');
    });

    return Scaffold(
      body: Center(
        child: Text(
          "Merchant App Splash Screen",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
