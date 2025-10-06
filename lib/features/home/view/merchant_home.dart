// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/ads/view/create_ad_screen.dart';
import 'package:merchantside_app/features/dashboard/view/dashboard_screen.dart';
import '../provider/nav_provider.dart';
import 'merchant_screens/payments_screen.dart';

class MerchantHome extends ConsumerWidget {
  const MerchantHome({super.key});

  static const _screens = [
    MerchantDashboardScreen(),
    PaymentsScreen(),
    CreateAdScreen(),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) => ref.read(navIndexProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Payments"),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: "Ads"),
        ],
      ),
    );
  }
}
