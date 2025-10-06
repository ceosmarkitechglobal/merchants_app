import 'package:flutter/material.dart';
import 'package:merchantside_app/features/dashboard/view/withdrawl_screen.dart';
import '../provider/merchant_provider.dart';

class MerchantDashboardScreen extends StatelessWidget {
  const MerchantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final earning = MerchantProvider.dummyEarning;
    final withdrawals = MerchantProvider.dummyWithdrawals;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Merchant Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF571094),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Earnings Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRow("Total Earnings", earning.totalEarnings),
                    _buildRow("Total Withdrawn", earning.totalWithdrawn),
                    _buildRow("Balance", earning.balance),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WithdrawalScreen()),
                );
              },
              child: Text("Request Withdrawal"),
            ),
            SizedBox(height: 20),
            Text(
              "Past Withdrawals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: withdrawals.length,
                itemBuilder: (_, index) {
                  final w = withdrawals[index];
                  return Card(
                    child: ListTile(
                      title: Text("\$${w.amount}"),
                      subtitle: Text(w.date),
                      trailing: Text(
                        w.status,
                        style: TextStyle(
                          color: w.status == "Success"
                              ? Colors.green
                              : w.status == "Pending"
                              ? Colors.orange
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text("\$${value.toStringAsFixed(2)}")],
      ),
    );
  }
}
