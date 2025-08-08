import 'package:flutter/foundation.dart';
import 'package:my_sales_app/data/models/store.dart';

class StoreProvider with ChangeNotifier {
  final List<Store> _stores = [
    Store(id: '1', name: 'فروشگاه الف', latitude: 35.7319, longitude: 51.3347, ownerName: 'رضا علوی', phoneNumber: '09121234567'),
    Store(id: '2', name: 'فروشگاه ب', latitude: 35.7219, longitude: 51.3447, ownerName: 'مهدی کریمی', phoneNumber: '09127654321'),
    Store(id: '3', name: 'فروشگاه ج', latitude: 35.7419, longitude: 51.3247, ownerName: 'سارا احمدی', phoneNumber: '09351112233'),
    Store(id: '4', name: 'فروشگاه د', latitude: 35.7119, longitude: 51.3547, ownerName: 'علی محمدی', phoneNumber: '09194445566'),
  ];

  List<Store> get stores => _stores;

  Store? findStoreById(String id) {
    return _stores.firstWhere((store) => store.id == id);
  }
}
