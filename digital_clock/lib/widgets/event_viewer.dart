import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:digital_clock/core/event.dart';
import 'package:digital_clock/development/logger.dart';
import 'package:digital_clock/widgets/event_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:digital_clock/common/constants.dart';

import 'package:flutter/services.dart';

final defaultEvent = Event(
  name: "default",
  imageFile: "assets/images/default.png",
  dates: [Date(start: "0101", end: "1231")]
);

class EventViewer extends StatefulWidget {
  final DateTime dateTime;

  EventViewer({
    Key key,
    this.dateTime,
  }) : super(key: key);

  @override
  _EventViewerState createState() => _EventViewerState();
}

class _EventViewerState extends State<EventViewer> {

  static List<Event> _events;

  @override
  void initState() {
    super.initState();
  }

  Future<Event> _lookupEvent() async {
    final date = DateFormat('MMdd').format(widget.dateTime);
    Event matched;

    if (_events == null) {
      String eventsJson = await rootBundle.loadString(Constants.eventsFile);
      Map<String, dynamic> eventsMap = jsonDecode(eventsJson);

      Events events = Events.fromJson(eventsMap);

      if (events != null) {
        _events = events.events;
      }

      Logger.debug("${_events?.length} events loaded in total.");
    }

    Logger.debug("look up event: date = $date [${widget.dateTime}]");

    if (_events == null) {
      return matched;
    }

    for (Event e in _events) {
      for (Date d in e.dates) {
        if (date.compareTo(d.start) >= 0
            && date.compareTo(d.end) <= 0) {
          matched = e;
        }
      }
    }

    if (matched == null) {
      Logger.debug("no matched event found. use default");

      matched = defaultEvent;
    }

    await matched.loadImage();

    Logger.debug("matched event: $matched");

    return matched;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _lookupEvent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }

          return CustomPaint(
            painter: EventPainter(snapshot.data?.image),
          );
        });
  }
}
