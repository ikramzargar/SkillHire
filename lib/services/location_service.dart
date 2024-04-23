import 'dart:developer';

import 'package:geolocator/geolocator.dart';

// Location service.
class Location {
  double? latitude;
  double? longitude;
// Function to get current location.
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      latitude = position.latitude;
      longitude = position.longitude;
      log('Location retrieved: $latitude, $longitude');
    } catch (e) {
      log('Error fetching location: $e');
    }
  }
}
