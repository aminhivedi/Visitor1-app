import 'package:flutter/material.dart';
import 'package:my_sales_app/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:my_sales_app/data/models/order.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سفارشات امروز'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'جستجو در سفارشات...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                // TODO: Implement search functionality
              },
            ),
          ),
          Expanded(
            child: orderProvider.todayOrders.isEmpty
                ? const Center(child: Text('سفارشی برای امروز ثبت نشده است.'))
                : ListView.builder(
                    itemCount: orderProvider.todayOrders.length,
                    itemBuilder: (context, index) {
                      final order = orderProvider.todayOrders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(order.storeName),
                          subtitle: Text(
                            '${intl.DateFormat('yyyy/MM/dd - HH:mm').format(order.orderTime)} - ${order.totalPrice} تومان'
                          ),
                          onTap: () {
                            _showOrderDetails(context, order);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('جزئیات سفارش ${order.storeName}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ویزیتور: ${order.visitorName}'),
                Text('تاریخ: ${intl.DateFormat('yyyy/MM/dd').format(order.orderTime)}'),
                Text('ساعت: ${intl.DateFormat('HH:mm').format(order.orderTime)}'),
                const Divider(),
                const Text('محصولات:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...order.items.map((item) => Text('${item.productName} (${item.quantity} عدد) - ${item.price} تومان')).toList(),
                const Divider(),
                Text('جمع کل: ${order.totalPrice} تومان', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('بستن'),
            ),
          ],
        ),
      ),
    );
  }
}
