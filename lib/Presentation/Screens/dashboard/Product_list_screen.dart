import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_sales_app/data/models/store.dart';
import 'package:my_sales_app/data/models/product.dart';
import 'package:my_sales_app/providers/store_provider.dart';
import 'package:my_sales_app/providers/product_provider.dart';
import 'package:my_sales_app/providers/order_provider.dart';
import 'package:my_sales_app/data/models/order.dart';

class ProductListScreen extends StatefulWidget {
  final String? storeId;
  const ProductListScreen({Key? key, this.storeId}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final Map<String, int> _selectedProducts = {};

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final Store? selectedStore = widget.storeId != null
        ? storeProvider.findStoreById(widget.storeId!)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedStore?.name ?? 'ثبت سفارش جدید'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return _buildProductItem(context, product);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedProducts.isNotEmpty
                  ? () => _showOrderSummary(context, selectedStore)
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('ادامه خرید'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('قیمت: ${product.price} تومان | موجودی: ${product.availableStock}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (_selectedProducts.containsKey(product.id) && _selectedProducts[product.id]! > 0) {
                    _selectedProducts[product.id] = _selectedProducts[product.id]! - 1;
                    if (_selectedProducts[product.id] == 0) {
                      _selectedProducts.remove(product.id);
                    }
                  }
                });
              },
            ),
            Text(_selectedProducts[product.id]?.toString() ?? '0'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  if (_selectedProducts.containsKey(product.id)) {
                    _selectedProducts[product.id] = _selectedProducts[product.id]! + 1;
                  } else {
                    _selectedProducts[product.id] = 1;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderSummary(BuildContext context, Store? store) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    double totalPrice = 0;
    List<OrderItem> orderItems = [];

    _selectedProducts.forEach((productId, quantity) {
      final product = productProvider.products.firstWhere((p) => p.id == productId);
      totalPrice += product.price * quantity;
      orderItems.add(OrderItem(
        productId: productId,
        productName: product.name,
        quantity: quantity,
        price: product.price,
      ));
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأیید سفارش'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (store != null)
                  Text('نام فروشگاه: ${store.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                if (store == null)
                  const Text('برای ثبت سفارش جدید، اطلاعات فروشگاه را وارد کنید.', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('جزئیات سفارش:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...orderItems.map((item) => Text('${item.productName}: ${item.quantity} عدد')).toList(),
                const Divider(),
                Text('جمع کل: $totalPrice تومان', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('انصراف'),
            ),
            ElevatedButton(
              onPressed: () {
                final newOrder = Order(
                  orderId: DateTime.now().millisecondsSinceEpoch.toString(),
                  storeName: store?.name ?? 'فروشگاه جدید',
                  orderTime: DateTime.now(),
                  visitorName: authProvider.visitorName,
                  items: orderItems,
                  totalPrice: totalPrice,
                );
                orderProvider.addOrder(newOrder);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سفارش با موفقیت ثبت شد.')),
                );
              },
              child: const Text('ثبت سفارش نهایی'),
            ),
          ],
        ),
      ),
    );
  }
}
