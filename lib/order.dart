double processOrder({
  required String orderId,
  required double itemPrice,
  String? promoCode,
  double? deliveryFee,
}) {
  double discount = 0.0;

  if (promoCode == 'SAVE10') {
    discount = itemPrice * 0.10;
  }

  double delivery = deliveryFee ?? 500.0;
  double finalTotal = itemPrice - discount + delivery;

  print('order id: $orderId');
  print('item price: $itemPrice');
  print('discount: $discount');
  print('delivery fee: $delivery');
  print('final total: $finalTotal');

  return finalTotal;
}

void main() {
  double total = processOrder(
    orderId: 'O001',
    itemPrice: 12550.0,
    promoCode: 'SAVE10',
    deliveryFee: 1050.0,
  );

  print('Total to pay: $total ₸');
}
