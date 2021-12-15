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
  void getLocationData() async {
    Map<String, dynamic> weatherData =
        await WeatherModel().getLocationWeather();

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
