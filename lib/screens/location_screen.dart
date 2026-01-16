import 'dart:async';
import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:glassmorphism/glassmorphism.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  double? temperature;
  String? weatherIcon;
  String? cityName;
  String? weatherMessage;

  double _x = 0, _y = 0;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        // Swapping x and y, and inverting one, can create a more natural parallax effect
        _x = (event.y / 15).clamp(-1, 1);
        _y = (-event.x / 15).clamp(-1, 1);
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }

      final num tempNum = weatherData['main']['temp'] as num;
      temperature = tempNum.toDouble();
      final int condition = (weatherData['weather'][0]['id'] as num).toInt();
      weatherIcon = weather.getWeatherIcon(condition);

      cityName = weatherData['name'] as String;
      final int tempInt = temperature!.round();
      weatherMessage = weather.getMessage(tempInt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(_x, _y),
            radius: 1.2,
            colors: [Color(0xFF65A4FF), Color(0xFF02367B)],
          ),
        ),
        child: Center(
          child: GlassmorphicContainer(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.85,
            borderRadius: 20,
            blur: 10,
            alignment: Alignment.center,
            border: 2,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
              stops: [0.1, 1],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.5),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () async {
                          var weatherData = await weather.getLocationWeather();
                          updateUI(weatherData);
                        },
                        icon: Icon(Icons.near_me, size: 50.0, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () async {
                          var typedName = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CityScreen();
                              },
                            ),
                          );
                          if (typedName != null) {
                            var weatherData =
                                await weather.getCityWeather(typedName);
                            updateUI(weatherData);
                          }
                        },
                        icon: Icon(Icons.location_city,
                            size: 50.0, color: Colors.white),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          temperature == null
                              ? '--'
                              : temperature!.toStringAsFixed(0),
                          style: kTempTextStyle,
                        ),
                        Text(
                          '°${weatherIcon ?? ''}',
                          style: kConditionTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Text(
                      '${weatherMessage ?? ''} in ${cityName ?? ''}',
                      textAlign: TextAlign.right,
                      style: kMessageTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
