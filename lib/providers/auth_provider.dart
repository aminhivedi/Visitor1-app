import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _visitorNationalId = '1234567890';
  String _visitorName = 'علی حسینی';

  bool get isAuthenticated => _isAuthenticated;
  String get visitorName => _visitorName;
  String get visitorNationalId => _visitorNationalId;

  Future<bool> login(String username, String password) async {
    if (username == 'admin' && password == 'admin') {
      _isAuthenticated = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_authenticated', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_authenticated');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('is_authenticated') ?? false;
    notifyListeners();
  }
}
