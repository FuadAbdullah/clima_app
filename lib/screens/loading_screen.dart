import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void testLocationPermission() {
    Geolocator.isLocationServiceEnabled().then(
      (bool allowed) {
        if (!allowed) {
          print('Location services are disabled');
        }

        Geolocator.checkPermission().then(
          (LocationPermission permission) {
            if (permission == LocationPermission.denied) {
              Geolocator.requestPermission().then(
                (LocationPermission permission) {
                  if (permission == LocationPermission.denied) {
                    print('Location permissions are denied');
                  }
                },
              );
            }

            if (permission == LocationPermission.deniedForever) {
              print(
                  'Location permissions are permanently denied, we cannot request permission.');
            }

            Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
                .then(
              (Position pos) {
                print(pos);
              },
            );
          },
        );
      },
    );
  }

  void getLocationData() async {
    Map<String, dynamic> weatherData =
        await WeatherModel().getLocationWeather();

    print(weatherData.keys);

    if (weatherData['error'] is FlutterError) {
      await Alert(
        closeFunction: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        style: AlertStyle(
          isOverlayTapDismiss: false,
          backgroundColor: Colors.blueGrey,
          titleStyle: TextStyle(
            color: Colors.white,
          ),
          descStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        context: context,
        type: AlertType.error,
        title: 'Error Encountered!',
        desc: weatherData['error'].toString(),
        buttons: [
          DialogButton(
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            color: Colors.redAccent,
            width: 120,
            child: Text(
              'Close App',
            ),
          ),
        ],
      ).show();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LocationScreen(
          weatherData: weatherData,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
