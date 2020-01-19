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

  Future<Event> _lookupEvents() async {
    final date = DateFormat('MMdd').format(widget.dateTime);
    List<Event> matched = List();
    Event picked = Constants.defaultEvent;

    if (_events == null) {
      Events events;

      try {
        String eventsJson = await rootBundle.loadString(Constants.eventsFile);
        Map<String, dynamic> eventsMap = jsonDecode(eventsJson);

        events = Events.fromJson(eventsMap);

      } catch (e) {
        Logger.error("parse events from ${Constants.eventsFile} failed: $e");

        events = null;
      }

      if (events != null) {
        _events = events.events;
      }

      Logger.debug("${_events?.length} events loaded in total.");
    }

    Logger.debug("look up event: date = $date [${widget.dateTime}]");

    if (_events == null) {
      return picked;
    }

    for (Event e in _events) {
      for (Date d in e.dates) {
        if (date.compareTo(d.start) >= 0
            && date.compareTo(d.end) <= 0) {
          matched.add(e);
        }
      }
    }

    if (matched.length > 0) {
      Logger.debug("pick a event from ${matched.length} matched event(s).");
      picked = matched[matched.length - 1];
    } else {
      Logger.debug("no matched event found. use default");
    }

    await picked.loadImage();

    Logger.info("picked event for [$date]: $picked");

    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _lookupEvents(),
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
