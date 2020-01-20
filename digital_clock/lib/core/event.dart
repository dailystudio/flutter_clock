import 'dart:typed_data';

import 'package:digital_clock/development/logger.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class Date {
  String start;
  String end;

  Date({
    this.start,
    this.end,
  });

  factory Date.fromJson(Map<String, dynamic> parsedJson) {
    return Date(
      start: parsedJson['start'],
      end: parsedJson['end'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'start': start,
        'end': end,
      };

  @override
  String toString() {
    return "($start, $end)";
  }
}

class Event {
  List<Date> dates;
  String name;
  String imageFile;

  img.Image image;

  Event({
    this.name,
    this.imageFile,
    this.dates,
  });

  Future<void> loadImage() async {
    if (image != null) {
      Logger.debug("using cached event image...");

      return;
    }

    Logger.debug("loading event image from assets ... [$imageFile]");

    ByteData data;
    try {
      data = await rootBundle.load(imageFile);
    } catch (e) {
      Logger.error("failed to load [$imageFile]: $e");

      data = null;
    }

    if (data == null) {
      return;
    }

    Uint8List bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    image = img.decodeImage(bytes);
  }

  factory Event.fromJson(Map<String, dynamic> parsedJson) {
    var datesFromJson = parsedJson['dates'];
    List<Date> dates =
        (datesFromJson as List).map((data) => new Date.fromJson(data)).toList();

    Event e = Event(
      name: parsedJson['name'],
      imageFile: parsedJson['image'],
      dates: dates,
    );

    return e;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'image': imageFile,
        'dates': dates,
      };

  @override
  String toString() {
    return "[$name]: dates = $dates, imageFile = $imageFile (image: $image)";
  }
}

class Events {
  int version;
  List<Event> events;

  Events({
    this.version,
    this.events,
  });

  factory Events.fromJson(Map<String, dynamic> parsedJson) {
    var eventsFromJson = parsedJson['events'];
    List<Event> events = (eventsFromJson as List)
        .map((data) => new Event.fromJson(data))
        .toList();

    return Events(
      version: parsedJson['version'],
      events: events,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'version': version,
        'events': events,
      };

  @override
  String toString() {
    return "events[ver: $version]: $events";
  }
}
