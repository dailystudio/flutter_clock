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
  fontSize: 18,
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
        color: Color(0xFF000910).withAlpha(220)
//        color: Colors.black
          ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
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
                      style: CLOCK_TIME_STYLE,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5, bottom: 12),
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
                  Text(
                    "${widget.model.temperatureString}",
                    style: CLOCK_DATE_STYLE,
                  ),
                  Text(
                    "${widget.model.location}",
                    style: CLOCK_DATE_STYLE,
                  ),
                ],
              ),
            ),
          )
        ]
      ),
    );
  }
}
