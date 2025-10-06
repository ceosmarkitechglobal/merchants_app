import 'package:merchantside_app/features/dashboard/data/merchant_data.dart';

class MerchantProvider {
  static Earning dummyEarning = Earning(
    totalEarnings: 5000,
    totalWithdrawn: 1500,
    balance: 3500,
  );

  static List<Withdrawal> dummyWithdrawals = [
    Withdrawal(amount: 500, date: "2025-10-01", status: "Success"),
    Withdrawal(amount: 200, date: "2025-10-04", status: "Pending"),
    Withdrawal(amount: 300, date: "2025-10-05", status: "Failed"),
  ];
}
