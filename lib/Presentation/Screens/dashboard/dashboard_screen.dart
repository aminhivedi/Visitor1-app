import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_sales_app/providers/store_provider.dart';
import 'package:my_sales_app/presentation/screens/map/map_screen.dart';
import 'package:my_sales_app/presentation/screens/orders/orders_screen.dart';
import 'package:my_sales_app/presentation/screens/settings/settings_screen.dart';
import 'package:my_sales_app/presentation/screens/dashboard/product_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const DashboardContent(),
    const MapScreen(),
    const OrdersScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('برنامه ویزیتور'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'داشبورد',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'نقشه',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'سفارشات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'تنظیمات',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    final unvisitedStores = storeProvider.stores.where((s) => !s.isVisited).toList();
    final visitedStores = storeProvider.stores.where((s) => s.isVisited).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildQuickOrderSection(context),
          const Divider(),
          _buildStoresSection(context, 'فروشگاه‌های بازدید نشده', unvisitedStores),
          const Divider(),
          _buildStoresSection(context, 'فروشگاه‌های بازدید شده', visitedStores),
        ],
      ),
    );
  }

  Widget _buildQuickOrderSection(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.add_shopping_cart, color: Colors.blue, size: 40),
        title: const Text('ثبت سفارش سریع', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('سفارش جدید برای فروشگاه جدید ثبت کنید.'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const ProductListScreen(storeId: null),
          ));
        },
      ),
    );
  }

  Widget _buildStoresSection(BuildContext context, String title, List stores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (stores.isEmpty)
          const Text('فروشگاهی در این لیست وجود ندارد.', style: TextStyle(color: Colors.grey))
        else
          ...stores.map((store) => Card(
            child: ListTile(
              title: Text(store.name),
              subtitle: Text(store.ownerName),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ProductListScreen(storeId: store.id),
                   ));
                },
              ),
            ),
          )).toList(),
      ],
    );
  }
}
