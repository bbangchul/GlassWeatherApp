import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

const String apikey = String.fromEnvironment('OPENWEATHER_API_KEY');

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
      'api.openweathermap.org',
      '/data/2.5/weather',
      {'q': cityName, 'appid': apikey, 'units': 'metric'},
    );

    var weahterData = await networkHelper.getData();
    return weahterData;
  }

  Future<dynamic> getLocationWeather() async {
    double? latitude;
    double? longitude;
    Location location = Location();

    await location.getCurrentLocation();

    latitude = location.latitude;
    longitude = location.longitude;

    NetworkHelper networkHelper =
        NetworkHelper('api.openweathermap.org', '/data/2.5/weather', {
          'lat': location.latitude.toString(),
          'lon': location.longitude.toString(),
          'appid': apikey,
          'units': 'metric',
        });

    var weatherData = await networkHelper.getData();

    return weatherData;
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
