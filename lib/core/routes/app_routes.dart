import 'package:flutter/material.dart';
import 'package:merchantside_app/features/auth/views/login_screen.dart';
import 'package:merchantside_app/features/auth/views/merchant_signup_screen.dart';
import 'package:merchantside_app/features/home/view/merchant_home.dart';
import '../../features/splash/view/splash_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/splash': (context) => const SplashScreen(),
  '/merchantlogin': (context) => const MerchantLoginScreen(),
  '/merchantsignup': (context) => const MerchantSignupScreen(),
  '/merchanthome': (context) => const MerchantHome(),
};
