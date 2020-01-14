import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class WeatherIcon extends StatefulWidget {
  final WeatherCondition weather;

  WeatherIcon({
    Key key,
    this.weather,
  }) : super(key: key);

  @override
  _WeatherIconState createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/weather/${describeEnum(widget.weather)}.png",
      width: 28,
      color: Colors.green,
    );
  }
}
