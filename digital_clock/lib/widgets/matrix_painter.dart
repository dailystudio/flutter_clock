import 'package:flutter/material.dart';
import 'package:digital_clock/development/logger.dart';
import 'package:digital_clock/common/constants.dart';

const MAX_CHARACTERS = 40;
const MIN_CHARACTERS = 16;
const MAX_SPEED = 6;

const TEXT_STYLE = TextStyle(
    color: Colors.green,
//    fontFamily: 'SourceCodePro-Bold',
//    fontFamily: 'CourierPrime-Bold',
    height: 1
);

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

    this.baseScale = 0.5 + randomSeed.nextDouble() * 0.5;

    this.size = _measureChars(text, this.baseScale);

    this.baseOffset = Offset(
        randomSeed.nextInt(boundary.width.round()).toDouble(),
        -size.height * (randomSeed.nextDouble() + 1)
    );

    this.speed = 1 + randomSeed.nextInt(MAX_SPEED);
    this.textPainter = createPainter();
  }

  TextPainter createPainter() {
    List<GradientColor> targetColors = List();

    targetColors.add(GradientColor(Colors.black, 0));
    targetColors.add(GradientColor(Colors.green, 0.3));
    targetColors.add(GradientColor(Colors.green, 0.8));
    targetColors.add(GradientColor(Colors.white, 1));

    List<Color> colors = calculateGradientColors(text.length, targetColors);

    final textStyle = TEXT_STYLE.copyWith(
      fontSize: 20 * this.baseScale
    );

    List<TextSpan> childSpans = List();
    for (int i = 0; i < text.length; i++) {
      final childStyle = textStyle.copyWith(
        color: colors[i]
      );

      childSpans.add(TextSpan(
          text: text.substring(i, i + 1),
          style:  childStyle
      ));
    }

    final textSpan = TextSpan(
      children: childSpans,
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
    final textStyle = TEXT_STYLE.copyWith(
        fontSize: 20 * scale
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
//    canvas.drawColor(Colors.black, BlendMode.src);

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

  void _generateNewStream(Size boundary) {
    int len = MIN_CHARACTERS + randomSeed.nextInt(MAX_CHARACTERS - MIN_CHARACTERS);

    _textStreams.add(TextStream(randomString(len), boundary));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}