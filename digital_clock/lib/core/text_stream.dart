import 'package:flutter/material.dart';
import 'package:digital_clock/common/constants.dart';

const MAX_CHARACTERS = 40;
const MIN_CHARACTERS = 16;
const MAX_SPEED = 6;

class TextStream {

  final String id;
  String text;
  int charsCount;
  Size size;

  Offset baseOffset;
  int yOffset = 0;

  int fontSize = DEFAULT_FONT_SIZE;
  double baseScale = 1.0;
  double scaleDelta = 0;

  int speed = 1;

  TextPainter textPainter;

  List<TextPainter> streamPainters = List();

  TextStream(this.id, this.text, Rect boundary, {int speed = -1}) {
    _configureStreamParameters(boundary, speed: speed);
  }

  void _configureStreamParameters(Rect boundary, {int speed = -1}) {
    this.charsCount = text.length;

    this.baseScale = 0.5 + randomSeed.nextDouble() * 0.5;

    this.speed = (speed == -1 ? (1 + randomSeed.nextInt(MAX_SPEED)) : speed);
    this.fontSize = (DEFAULT_FONT_SIZE * this.baseScale).round();

    _pickupPainters();

    this.size = _calculatePaintersSize();

    this.baseOffset = Offset(
        boundary.left + randomSeed.nextInt(boundary.width.round()).toDouble(),
        -size.height * (randomSeed.nextDouble() + 1)
    );
  }

  void _pickupPainters() {
    streamPainters.clear();

    String key;
    for (int i = 0; i < text.length; i++) {
      if (i < LEADING_CHARACTERS) {
        key = "${text[i]}.L$i.$fontSize";
      } else if (i >= text.length - TAIL_CHARACTERS) {
        key = "${text[i]}.T${TAIL_CHARACTERS - (text.length - i)}.$fontSize";
      } else {
        key = "${text[i]}.B.$fontSize";
      }

      final TextPainter tp = TEXT_PAINTERS[key];
//      Logger.debug('picking up key: $key, tp: $tp');
      if (tp == null) {
        continue;
      }

      streamPainters.add(tp);
    }
  }

  Size _calculatePaintersSize() {
    double width = 0;
    double height = 0;
    for (var tp in streamPainters) {
      if (tp.width > width) {
        width = tp.width;
      }

      height += tp.height;
    }

    return Size(width, height);
  }

  void randomizeChars() {
    text = randomString(charsCount);

    _pickupPainters();
  }

}
