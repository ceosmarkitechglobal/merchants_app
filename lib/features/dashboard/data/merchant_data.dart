class Earning {
  final double totalEarnings;
  final double totalWithdrawn;
  final double balance;

  Earning({
    required this.totalEarnings,
    required this.totalWithdrawn,
    required this.balance,
  });
}

class Withdrawal {
  final double amount;
  final String date;
  final String status;

  Withdrawal({required this.amount, required this.date, required this.status});
}
