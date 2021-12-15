import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentPosition() async {
    bool locationServiceStatus = await Geolocator.isLocationServiceEnabled();

    if (!locationServiceStatus) {
      print('Location services are disabled');
    }

    LocationPermission checkPermission = await Geolocator.checkPermission();

    if (checkPermission == LocationPermission.denied) {
      LocationPermission requestPermission =
          await Geolocator.requestPermission();
      if (requestPermission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    } else if (checkPermission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permission.');
    } else {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );
        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        print(e);
        // TODO: Handle location service retrieval error here
        // Maybe display a popup to tell the user to enable location service
        // and end the application
      }
    }
  }
}
