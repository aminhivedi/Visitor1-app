class Store {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String ownerName;
  final String phoneNumber;
  bool isVisited;

  Store({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.ownerName,
    required this.phoneNumber,
    this.isVisited = false,
  });
}
