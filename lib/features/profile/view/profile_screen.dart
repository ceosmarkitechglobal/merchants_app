// lib/features/profile/view/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileProvider.notifier).fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Merchant Profile")),
      body: Center(
        child: switch (profileState.status) {
          ProfileStatus.loading => const CircularProgressIndicator(),
          ProfileStatus.error => Text("Error: ${profileState.message}"),
          ProfileStatus.success =>
            profileState.data == null
                ? const Text("No profile data")
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Shop Name: ${profileState.data!['shop_name']}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Category: ${profileState.data!['category']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Email: ${profileState.data!['email']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Approved: ${profileState.data!['isApproved']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Bank Details:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Bank Name: ${profileState.data!['bank_details']['bank_name']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Account Number: ${profileState.data!['bank_details']['account_number']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "IFSC Code: ${profileState.data!['bank_details']['ifsc_code']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Holder Name: ${profileState.data!['bank_details']['holder_name']}",
                          style: const TextStyle(fontSize: 16),
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
