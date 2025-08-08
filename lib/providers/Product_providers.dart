import 'package:flutter/foundation.dart';
import 'package:my_sales_app/data/models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(id: 'p1', name: 'محصول ۱', availableStock: 100, price: 15000),
    Product(id: 'p2', name: 'محصول ۲', availableStock: 50, price: 25000),
    Product(id: 'p3', name: 'محصول ۳', availableStock: 200, price: 5000),
  ];

  List<Product> get products => _products;
}
