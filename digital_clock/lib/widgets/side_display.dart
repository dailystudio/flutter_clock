import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/cupertino.dart';

const CLOCK_TIME_STYLE = TextStyle(
  color: Colors.green,
  fontSize: 72,
  fontWeight: FontWeight.bold,
);

const CLOCK_APM_STYLE = TextStyle(
  color: Colors.green,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const CLOCK_DATE_STYLE =
    TextStyle(color: Colors.green, fontSize: 18, fontStyle: FontStyle.italic);

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

    return Container(
      decoration: BoxDecoration(
//        color: Colors.white.withAlpha(128)
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$hour:$minute",
                style: CLOCK_TIME_STYLE,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 12),
                child: Text(
                  "$amOrPm",
                  style: CLOCK_APM_STYLE,
                ),
              )
            ],
          ),
          Text(
            "$date",
            style: CLOCK_DATE_STYLE,
          )
        ],
      ),
    );
  }
}