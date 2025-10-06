import 'package:flutter/material.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/home/view/merchant_home.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const MerchantSplashScreen(),
  '/merchanthome': (context) => const MerchantHome(),
  '/login': (context) => const MerchantLoginScreen(),
};
