import 'package:clima/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'get_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clima/services/weather.dart';

// NOTE: keep API keys out of source control in real apps.

class LoadingScreen extends StatefulWidget {
  LoadingScreen({this.locationWeather});

  final dynamic locationWeather;

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLocationData();
  }

  Future<void> getLocationData() async {
    var weatherData = await WeatherModel().getLocationWeather();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocationScreen(locationWeather: weatherData);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SpinKitDoubleBounce(color: Colors.white, size: 100)),
    );
  }
}
