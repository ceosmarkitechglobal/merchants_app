// lib/features/withdrawal/view/withdrawal_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/withdraw/provider/withdrawal_provider.dart';

class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  ConsumerState<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitWithdrawal() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter withdrawal amount')));
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    await ref.read(withdrawProvider.notifier).withdraw(amount);
    final state = ref.read(withdrawProvider);
    if (state.message != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message!)));
    }
    if (state.status == WithdrawStatus.success) {
      _amountController.clear();
      ref.read(withdrawProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final withdrawState = ref.watch(withdrawProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Withdraw')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: withdrawState.status == WithdrawStatus.loading
                  ? null
                  : _submitWithdrawal,
              child: withdrawState.status == WithdrawStatus.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Withdrawal'),
            ),
          ],
        ),
      ),
    );
  }
}
