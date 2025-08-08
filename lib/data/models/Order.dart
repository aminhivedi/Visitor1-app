class Order {
  final String orderId;
  final String storeName;
  final DateTime orderTime;
  final String visitorName;
  final List<OrderItem> items;
  final double totalPrice;

  Order({
    required this.orderId,
    required this.storeName,
    required this.orderTime,
    required this.visitorName,
    required this.items,
    required this.totalPrice,
  });
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });
}
