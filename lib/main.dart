import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/home/view/merchant_home.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merchant App',
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MerchantHome(),
    );
  }
}
