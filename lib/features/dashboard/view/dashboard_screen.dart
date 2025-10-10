// lib/features/dashboard/view/merchant_dashboard_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/dashboard/provider/merchant_provider.dart';
import 'package:merchantside_app/features/profile/view/profile_screen.dart';
import 'package:merchantside_app/features/withdraw/view/withdrawal_screen.dart';

class MerchantDashboardScreen extends ConsumerStatefulWidget {
  const MerchantDashboardScreen({super.key});

  @override
  ConsumerState<MerchantDashboardScreen> createState() =>
      _MerchantDashboardScreenState();
}

class _MerchantDashboardScreenState
    extends ConsumerState<MerchantDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboardProvider.notifier).getDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person), // Profile icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(), // Navigate to profile
                ),
              );
            },
          ),
        ],
      ),

      body: Center(
        child: switch (dashboardState.status) {
          DashboardStatus.loading => const CircularProgressIndicator(),
          DashboardStatus.error => Text('Error: ${dashboardState.message}'),
          DashboardStatus.success =>
            dashboardState.data == null
                ? const Text('No data available')
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shop Name: ${dashboardState.data!['shop_name']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Category: ${dashboardState.data!['category']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Total Payments: ${dashboardState.data!['totalPayments']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Total Earnings: ${dashboardState.data!['totalEarnings']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WithdrawalScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.money),
                          label: const Text('Withdraw Funds'),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Recent Transactions:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        dashboardState.data!['recentTransactions'].isEmpty
                            ? const Text('No recent transactions')
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: dashboardState
                                      .data!['recentTransactions']
                                      .length,
                                  itemBuilder: (context, index) {
                                    final tx = dashboardState
                                        .data!['recentTransactions'][index];
                                    return ListTile(
                                      title: Text(tx['title'] ?? 'Transaction'),
                                      subtitle: Text(tx['amount'].toString()),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
