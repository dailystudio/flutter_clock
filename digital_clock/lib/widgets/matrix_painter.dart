import 'dart:math';

import 'package:digital_clock/development/logger.dart';
import 'package:flutter/material.dart';

const CHARSET = "abcdefghijklmnopqrstuvwxyz0123456789";
const MAX_CHARACTERS = 36;
const MIN_CHARACTERS = 10;
const MAX_SPEED = 6;

class TextStream {

  TextPainter painter;
  Offset baseOffset;

  Size size;
  int yOffset = 0;
  int speed = 1;

  TextStream(TextPainter painter, Offset baseOffset, Size size, int speed) {
    this.painter = painter;
    this.size = size;
    this.baseOffset = baseOffset;
    this.speed = speed;
  }

}

class MatrixPainter extends CustomPainter {

  static final _textStyle = TextStyle(
      color: Colors.green,
      fontSize: 20,
      height: 1
  );

  static final _randomSeed = Random(DateTime.now().millisecondsSinceEpoch);

  double _position = 0;
  static int _loop = 0;
  static List<TextStream> _textStreams = List();

  MatrixPainter(double position, int loop) {
//    Logger.debug('pos: $position, loop: $loop [old: $_loop]');
    this._position = position;

    if (_loop != loop) {
      _textStreams.clear();
    }

    _loop = loop;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.black, BlendMode.src);

    if (_position.round() % 10 == 0) {
      _generateNewStream(size);
    }

    for (TextStream stream in _textStreams) {
      final dx = stream.baseOffset.dx;
      final dy = stream.baseOffset.dy + stream.yOffset;

      stream.yOffset += stream.speed;

      if (dy < -stream.size.height || dy  > size.height) {
        continue;
      }

      final offset = Offset(dx, dy);

      stream.painter.paint(canvas, offset);

    }
  }

  Size _measureChars(String chars) {
    final singleCharTextSpan = TextSpan(
      text: chars,
      style: _textStyle,
    );

    final painter = TextPainter(
      text: singleCharTextSpan,
      textDirection:  TextDirection.ltr,
      textAlign: TextAlign.center
    );

    painter.layout(
      minWidth: 0,
      maxWidth: 0,
    );

    return Size(painter.minIntrinsicWidth, painter.height);
  }

  Size _measureCharsAverage(String chars) {
    final totalSize = _measureChars(chars);

    return Size(totalSize.width,
        totalSize.height / chars.length);
  }

  String _randomString(int len) {
    String result = "";

    for (int i = 0; i < len; i++) {
      int index = _randomSeed.nextInt(CHARSET.length);

        result += CHARSET[index];
    }

    return result;
  }

  void _generateNewStream(Size boundary) {

    int len = MIN_CHARACTERS + _randomSeed.nextInt(MAX_CHARACTERS - MIN_CHARACTERS);
    String text = _randomString(len);
//    String text = CHARSET;
    Size size = _measureChars(text);
//    Size size = Size(17, CHARSET.length * 35.0);
//    Logger.debug('new stream: [$text], size: $size');

    final textSpan = TextSpan(
      text: text,
      style: _textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
        minWidth: 0,
        maxWidth: 0,
    );

    Offset offset = Offset(
      _randomSeed.nextInt(boundary.width.round()).toDouble(),
      -size.height * (_randomSeed.nextDouble() + 1)
    );

    int speed = 1 + _randomSeed.nextInt(MAX_SPEED);

    _textStreams.add(TextStream(textPainter, offset, size, speed));
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}