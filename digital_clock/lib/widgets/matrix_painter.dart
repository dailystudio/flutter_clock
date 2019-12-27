import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:digital_clock/development/logger.dart';
import 'package:digital_clock/common/constants.dart';
import 'package:digital_clock/core/clock_digits.dart';
import 'package:digital_clock/core/clock_face_painter.dart';
import 'package:digital_clock/core/text_stream.dart';

class MatrixPainter extends CustomPainter {

  String time;
  double _position = 0;
  static int _loop = 0;
  static List<TextStream> _textStreams = List();

  ClockDigits _clockDigits;

  MatrixPainter(this.time, double position, int loop, Map<String, ui.Image> assets) {
    buildTextPainters();
//    Logger.debug('pos: $position, loop: $loop [old: $_loop]');
    this._position = position;

    if (_loop != loop) {
      _textStreams.clear();
    }

    _clockDigits = ClockDigits(time, assets);

    _loop = loop;
  }

  @override
  void paint(Canvas canvas, Size size) {
//    canvas.drawColor(Colors.black, BlendMode.src);

    if (_position.round() % STREAM_GENERATION_INTERVAL == 0) {
//      TextStream ts = _clockDigits.randomCreateTextStream();
//      if (ts == null) {
//        ts = _generateNewStream(Rect.fromLTWH(0, 0, size.width, size.height));
//      }


      var ts;
      ts = _generateNewStream(Rect.fromLTWH(0, 0, size.width, size.height));
      _textStreams.add(ts);
    }

    paintStreams(canvas, size, _textStreams);
    _clockDigits.layout(size);
    _clockDigits.paint(canvas, size);
  }

  void paintStreams(Canvas canvas, Size size, List<TextStream> streams) {
    List<TextStream> useless = List();

    for (TextStream stream in streams) {
//      if (stream.id.startsWith("DS")) {
//        stream.randomizeChars();
//      }

      final dx = stream.baseOffset.dx;
      final dy = stream.baseOffset.dy + stream.yOffset;

      stream.yOffset += stream.speed;
      stream.scaleDelta += 0.001;

      if (dy < -stream.size.height || dy  > size.height) {
        if (dy > size.height) {
          useless.add(stream);
        }

        continue;
      }

//      final offset = Offset(dx, dy);

      double yOffset = 0;
      for (int i = 0; i < stream.charsCount; i++) {
        TextPainter tp = stream.streamPainters[i];
        final charOffset = Offset(
            dx,
            dy + yOffset
        );

//        if (_clockDigits.isInBoundaries(charOffset.dx, charOffset.dy)) {
//          String ch = stream.text[i];
//          tp = TEXT_PAINTERS["$ch.T4.${stream.fontSize}"];
//        }

        if (tp != null) {
          tp.paint(canvas, charOffset);
          yOffset += tp.height;
        }
      }

//      stream.textPainter.paint(canvas, offset);
    }

    for (TextStream s in useless) {
      streams.remove(s);
    }
  }

  String _randomPickup(String old) {
    String newString = old;
    for (int i = 0; i < 3; i++) {
      int position = randomSeed.nextInt(old.length);
      int index = randomSeed.nextInt(CHARSET.length);
      String char = CHARSET[index];

      newString = _replaceCharAt(newString, position, char);
    }
    
    return newString;
  }

  String _replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }

  TextStream _generateNewStream(Rect boundary) {
    int len = MIN_CHARACTERS + randomSeed.nextInt(MAX_CHARACTERS - MIN_CHARACTERS);

    int id = DateTime.now().millisecondsSinceEpoch;

    return TextStream("C$id", randomString(len), boundary);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}