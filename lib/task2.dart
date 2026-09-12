void chBalance({required String name, required double balance}) =>
    print('$name, your current balance is $balance');

double deposit({required double currentBalance, double? amount}) {
  double depositAmount = amount ?? 0.0;
  double newBalance = currentBalance + depositAmount;

  print('Deposit $depositAmount');
  print('New balance $newBalance');
  return newBalance;
}

double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  int pin = pinCode ?? 0000;
  double withdrawAmount = amount ?? 0.0;

  if (pin != 2007) {
    print('Incorrect PIN code');
    return currentBalance;
  }

  if (withdrawAmount > currentBalance) {
    print('Insufficient funds. Transaction declined.');
    return currentBalance;
  }

  double newBalance = currentBalance - withdrawAmount;

  print('$name withdrew $withdrawAmount');
  print('Remaining balance: $newBalance');
  return newBalance;
}

void main() {
  double balance = 1123.0;
  chBalance(name: 'Aidos', balance: balance);

  balance = deposit(currentBalance: balance, amount: 350.0);

  balance = withdraw(
    name: 'Aidos',
    currentBalance: balance,
    amount: 250.0,
    pinCode: 2006,
  );

  balance = withdraw(
    name: 'Aidos',
    currentBalance: balance,
    amount: 200.0,
    pinCode: 2007,
  );
  chBalance(name: 'Aidos', balance: balance);
}
