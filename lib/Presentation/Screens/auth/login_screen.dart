import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_sales_app/providers/auth_provider.dart';
import 'package:my_sales_app/presentation/screens/dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController(text: 'admin');
  final TextEditingController _passwordController = TextEditingController(text: 'admin');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ورود به سیستم'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'نام کاربری (admin)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'رمز عبور (admin)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  bool success = await authProvider.login(
                      _usernameController.text, _passwordController.text);
                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('نام کاربری یا رمز عبور اشتباه است')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('ورود'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
