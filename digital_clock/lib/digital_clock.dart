// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/widgets/matrix_viewer.dart';
import 'package:digital_clock/widgets/side_display.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'development/logger.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.green,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.white,
  _Element.text: Colors.blue,
  _Element.shadow: Colors.white,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();

    Logger.setDebugEnabled(!kReleaseMode);
    Logger.info(
        'applicatio is running in ${kReleaseMode ? "release" : "debug"} mode');

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final date = DateFormat('MMMM d, yyyy').format(_dateTime);
    final apm = DateFormat('aaa').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 7.5;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'MontserratAlternates',
      fontSize: fontSize,
//      shadows: [
//        Shadow(
//          blurRadius: 0,
//          color: colors[_Element.shadow],
//          offset: Offset(10, 0),
//        ),
//      ],
    );

    return Container(
      constraints: BoxConstraints.expand(),
      child: Stack(
        children: <Widget>[
          Positioned(  //
            left: 0, right: 0, top: 0, bottom: 0,
            child: Image(
              image: AssetImage('assets/images/background.jpg'),
              fit : BoxFit.cover,
            ),
          ),

          Positioned(  //
            left: 0, right: 0, top: 0, bottom: 0,
            child: MatrixViewer(model: widget.model),
          ),

          Positioned(
            right: 0, top: 0, bottom: 0,
            child: Container(  //
              constraints: BoxConstraints.expand(
                width: 230
              ),
              child: SideDisplay(
                dateTime: _dateTime,
                model: widget.model,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
