import 'package:flutter/foundation.dart';
import 'package:my_sales_app/data/models/order.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _todayOrders = [];

  List<Order> get todayOrders => _todayOrders;

  void addOrder(Order order) {
    _todayOrders.add(order);
    notifyListeners();
  }
}
