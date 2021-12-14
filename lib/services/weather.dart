import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

const String apiKey = '9d16a3f043f0e01c4338bf22cc3b07fc';
const String openWeatherMapURL =
    'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<Map<String, dynamic>> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
        url: '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric');

    return await networkHelper.getData();
  }

  Future<Map<String, dynamic>> getLocationWeather() async {
    Location currentLocation = Location();
    await currentLocation.getCurrentPosition();

    NetworkHelper networkHelper = NetworkHelper(
        url:
            '$openWeatherMapURL?lat=${currentLocation.latitude}&lon=${currentLocation.longitude}&appid=$apiKey&units=metric');

    return await networkHelper.getData();
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
