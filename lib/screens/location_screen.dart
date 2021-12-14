import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LocationScreen extends StatefulWidget {
  final Map<String, dynamic>? weatherData;

  LocationScreen({required this.weatherData});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  int? temperature;
  String? weatherIcon;
  String? weatherDescription;
  String? cityName;

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData!);
  }

  void updateUI(Map<String, dynamic> weatherData) {
    setState(() {
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      weatherIcon =
          weatherModel.getWeatherIcon(weatherData['weather'][0]['id']);
      weatherDescription = weatherModel.getMessage(temperature!);
      cityName = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      Map<String, dynamic> latestWeatherData =
                          await weatherModel.getLocationWeather();
                      updateUI(latestWeatherData);
                      print('refreshed');
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      final dynamic newCityName =
                          await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => CityScreen(
                            cityName: cityName!,
                          ),
                        ),
                      );
                      updateUI(await weatherModel.getCityWeather(newCityName));
                      print('refreshed');
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${temperature!.toString()}°',
                        style: kTempTextStyle,
                      ),
                      Text(
                        weatherIcon!,
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: AutoSizeText(
                    '$weatherDescription in $cityName',
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
