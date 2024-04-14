import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Location permission denied.');
      LocationPermission permissionRequest = await Geolocator.requestPermission();
      if (permissionRequest == LocationPermission.denied) {
        print('Location permission still denied.');
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      latitude = position.latitude;
      longitude = position.longitude;
      print('Location retrieved: $latitude, $longitude');
    } catch (e) {
      print('Error fetching location: $e');
    }
  }
}