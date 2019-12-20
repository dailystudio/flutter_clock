import 'dart:math';

import 'package:digital_clock/development/logger.dart';
import 'package:flutter/material.dart';

const CHARSET = "abcdefghijklmnopqrstuvwxyz0123456789";
const MAX_CHARACTERS = 40;
const MIN_CHARACTERS = 16;
const MAX_SPEED = 6;

const TEXT_STYLE = TextStyle(
    color: Colors.green,
    fontSize: 20,
    height: 1
);

final _randomSeed = Random(DateTime.now().millisecondsSinceEpoch);

class TextStream {

  final String text;
  int charsCount;
  Size size;

  Offset baseOffset;
  int yOffset = 0;

  double baseScale = 1.0;
  double scaleDelta = 0;

  int speed = 1;

  TextPainter textPainter;

  TextStream(this.text, Size boundary) {
    _configureStreamParameters(boundary);
  }

  void _configureStreamParameters(Size boundary) {
    this.charsCount = text.length;

    this.baseScale = 0.5 + _randomSeed.nextDouble() * 0.5;

    this.size = _measureChars(text, this.baseScale);

    this.baseOffset = Offset(
        _randomSeed.nextInt(boundary.width.round()).toDouble(),
        -size.height * (_randomSeed.nextDouble() + 1)
    );

    this.speed = 1 + _randomSeed.nextInt(MAX_SPEED);
    this.textPainter = createPainter();
  }

  TextPainter createPainter() {
    final textStyle = TextStyle(
        color: Colors.green,
        fontSize: 20 * baseScale,
        height: 1
    );

    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );


    TextPainter painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    painter.layout(
      minWidth: 0,
      maxWidth: 0,
    );

    return painter;
  }

  static Size _measureChars(String chars, double scale) {
    final textStyle = TextStyle(
        color: Colors.green,
        fontSize: 20 * scale,
        height: 1
    );

    final singleCharTextSpan = TextSpan(
      text: chars,
      style: textStyle,
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

}

class MatrixPainter extends CustomPainter {

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

    List<TextStream> useless = List();

    for (TextStream stream in _textStreams) {
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

      final offset = Offset(dx, dy);

      stream.textPainter.paint(canvas, offset);
    }

    for (TextStream s in useless) {
      _textStreams.remove(s);
    }
  }

  String _randomPickup(String old) {
    String newString = old;
    for (int i = 0; i < 3; i++) {
      int position = _randomSeed.nextInt(old.length);
      int index = _randomSeed.nextInt(CHARSET.length);
      String char = CHARSET[index];

      newString = _replaceCharAt(newString, position, char);
    }
    
    return newString;
  }

  String _replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }

  Size _measureChars(String chars) {
    final singleCharTextSpan = TextSpan(
      text: chars,
      style: TEXT_STYLE,
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

    _textStreams.add(TextStream(_randomString(len), boundary));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}