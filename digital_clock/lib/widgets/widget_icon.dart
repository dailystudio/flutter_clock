import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherIcon extends StatefulWidget {
  @override
  _WeatherIconState createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> {
  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/weather/rainy.png",
      width: 28,
      color: Colors.green,
    );
  }
}