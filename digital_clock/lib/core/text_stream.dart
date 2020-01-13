import 'package:digital_clock/development/logger.dart';
import 'package:flutter/material.dart';
import 'package:digital_clock/common/constants.dart';

class TextStream {

  final String id;
  String text;
  int charsCount;
  Size size;

  Offset baseOffset;
  int yOffset = 0;

  int fontSize = Configuration.defaultFontSize;
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

    this.baseScale = 0.5 + Constants.randomSeed.nextDouble() * 0.5;

    this.speed = (speed == -1 ? (1 + Constants.randomSeed.nextInt(Configuration.maxStreamSpeed)) : speed);
    this.fontSize = (Configuration.defaultFontSize * this.baseScale).round();

    _pickupPainters();

    this.size = _calculatePaintersSize();

    this.baseOffset = Offset(
        boundary.left + Constants.randomSeed.nextInt(boundary.width.round()).toDouble(),
        -size.height * (Constants.randomSeed.nextDouble() + 1)
    );
  }

  void _pickupPainters() {
    streamPainters.clear();

    String key;
    for (int i = 0; i < text.length; i++) {
      if (i < Configuration.leadingCharacters) {
        key = "${text[i]}.L$i.$fontSize";
      } else if (i >= text.length - Configuration.tailCharacters) {
        key = "${text[i]}.T${Configuration.tailCharacters - (text.length - i)}.$fontSize";
      } else {
        key = "${text[i]}.B.$fontSize";
      }

      final TextPainter tp = Constants.textPainters[key];
      if (tp == null) {
        Logger.warn("text painter for character [${text[i]}] does NOT exist.");
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
    text = Constants.randomString(charsCount);

    _pickupPainters();
  }

}
