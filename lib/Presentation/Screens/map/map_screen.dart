import 'package:flutter/material.dart';
import 'package:Maps_flutter/Maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_sales_app/data/models/store.dart';
import 'package:provider/provider.dart';
import 'package:my_sales_app/providers/store_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_sales_app/presentation/screens/dashboard/product_list_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(35.7219, 51.3347); // Tehran
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _requestPermissionAndGetLocation();
  }

  Future<void> _requestPermissionAndGetLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }
    _loadStoreMarkers();
  }

  void _loadStoreMarkers() {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    setState(() {
      _markers = storeProvider.stores.map((store) {
        return Marker(
          markerId: MarkerId(store.id),
          position: LatLng(store.latitude, store.longitude),
          infoWindow: InfoWindow(
            title: store.name,
            snippet: 'کلیک برای جزئیات',
            onTap: () => _showStoreBottomSheet(context, store),
          ),
        );
      }).toSet();
    });
  }

  void _showStoreBottomSheet(BuildContext context, Store store) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(store.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('صاحب: ${store.ownerName}'),
              Text('تلفن: ${store.phoneNumber}'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse("google.navigation:q=${store.latitude},${store.longitude}");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('نرم‌افزار نقشه یافت نشد.')),
                    );
                  }
                },
                icon: const Icon(Icons.directions),
                label: const Text('مسیریابی'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProductListScreen(storeId: store.id),
                  ));
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('ثبت سفارش جدید'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12.0,
            ),
            markers: _markers,
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'جستجوی فروشگاه یا صاحب آن',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (query) {
                // TODO: Implement search and map filtering
              },
            ),
          ),
        ],
      ),
    );
  }
}
