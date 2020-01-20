import 'dart:math';

import 'package:digital_clock/common/constants.dart';
import 'package:digital_clock/widgets/widget_icon.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/cupertino.dart';

class SideDisplay extends StatefulWidget {
  final DateTime dateTime;
  final ClockModel model;

  SideDisplay({
    Key key,
    this.dateTime,
    this.model,
  }) : super(key: key);

  @override
  _SideDisplayState createState() => _SideDisplayState();
}

class _SideDisplayState extends State<SideDisplay>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = widget.dateTime;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(dateTime);
    final minute = DateFormat('mm').format(dateTime);
    final date = DateFormat('MMMM d, yyyy').format(dateTime);
    final amOrPm = DateFormat('aaa').format(dateTime);

    String location = widget.model.location?.toString();
    if (location != null) {
      location = location.substring(
          0, min(location.length, Configuration.maxLocationTextLength));
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withAlpha((255 * Configuration.sideDisplayOpacity).round())
      ),
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Positioned(
          top: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "$hour:$minute",
                    style: Constants.clockTimeStyle,
                  ),
                  Offstage(
                    offstage: widget.model.is24HourFormat,
                    child: Container(
                      padding: EdgeInsets.only(left: 5, bottom: 12),
                      child: Text(
                        "$amOrPm",
                        style: Constants.clockAmOrPmStyle,
                      ),
                    ),
                  )
                ],
              ),
              Text(
                "$date",
                style: Constants.clockDateStyle,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: WeatherIcon(
                        weather: widget.model.weatherCondition,
                      ),
                    ),
                    Text(
                      "${widget.model.temperatureString}",
                      style: Constants.clockDateStyle,
                    ),
                  ],
                ),
                Text(
                  "$location",
                  style: Constants.clockDateStyle,
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
