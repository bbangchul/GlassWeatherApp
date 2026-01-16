import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:glassmorphism/glassmorphism.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  String? cityName;

  double _x = 0, _y = 0;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Make scaffold background transparent to see the gradient
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(_x, _y),
            radius: 1.2,
            colors: [Color(0xFF6E6E6E), Color(0xFF242424)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios,
                      size: 50.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              GlassmorphicContainer(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        style: TextStyle(color: Color(0xE6FFFFFF)),
                        decoration: kTextFieldInputDecoration,
                        onChanged: (value) {
                          cityName = value;
                        },
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, cityName);
                        },
                        child: Text('Get Weather', style: kButtonTextStyle),
                      ),
                    ],
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
