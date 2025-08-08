import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_sales_app/providers/auth_provider.dart';
import 'package:my_sales_app/presentation/screens/auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('اطلاعات ویزیتور'),
            subtitle: Text('نام: ${authProvider.visitorName}\nکد ملی: ${authProvider.visitorNationalId}'),
            leading: const Icon(Icons.person),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('حالت شب'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (bool value) {
              // TODO: Implement theme change logic
            },
            secondary: const Icon(Icons.nights_stay),
          ),
          ListTile(
            title: const Text('تغییر رمز عبور'),
            leading: const Icon(Icons.lock),
            onTap: () {
              // TODO: Navigate to change password screen
            },
          ),
          ListTile(
            title: const Text('درباره برنامه'),
            leading: const Icon(Icons.info),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'برنامه ویزیتور',
                applicationVersion: '1.0.0',
                children: [
                  const Text('این برنامه برای مدیریت سفارشات ویزیتورها طراحی شده است.'),
                ],
              );
            },
          ),
          ListTile(
            title: const Text('خروج از حساب کاربری'),
            leading: const Icon(Icons.logout),
            onTap: () {
              authProvider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
