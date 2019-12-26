import 'dart:math';

import 'dart:ui';

import 'package:digital_clock/development/logger.dart';
import 'package:flutter/material.dart';

const CHARSET = 'abcdefghijklmnopqrstuvwxyz' +
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
    '0123456789' +
//    '\u{30A0}\u{30A1}\u{30A2}\u{30A3}\u{30A4}\u{30A5}\u{30A6}\u{30A7}\u{30A8}\u{30A9}\u{30AA}\u{30AB}\u{30AC}\u{30AD}\u{30AE}\u{30AF}' +
//    '\u{30B0}\u{30B1}\u{30B2}\u{30B3}\u{30B4}\u{30B5}\u{30B6}\u{30B7}\u{30B8}\u{30B9}\u{30BA}\u{30BB}\u{30BC}\u{30BD}\u{30BE}\u{30BF}' +
//    '\u{30C0}\u{30C1}\u{30C2}\u{30C3}\u{30C4}\u{30C5}\u{30C6}\u{30C7}\u{30C8}\u{30C9}\u{30CA}\u{30CB}\u{30CC}\u{30CD}\u{30CE}\u{30CF}' +
//    '\u{30D0}\u{30D1}\u{30D2}\u{30D3}\u{30D4}\u{30D5}\u{30D6}\u{30D7}\u{30D8}\u{30D9}\u{30DA}\u{30DB}\u{30DC}\u{30DD}\u{30DE}\u{30DF}' +
//    '\u{30E0}\u{30E1}\u{30E2}\u{30E3}\u{30E4}\u{30E5}\u{30E6}\u{30E7}\u{30E8}\u{30E9}\u{30EA}\u{30EB}\u{30EC}\u{30ED}\u{30EE}\u{30EF}' +
//    '\u{30F0}\u{30F1}\u{30F2}\u{30F3}\u{30F4}\u{30F5}\u{30F6}\u{30F7}\u{30F8}\u{30F9}\u{30FA}\u{30FB}\u{30FC}\u{30FD}\u{30FE}\u{30FF}' +
    '';

const TEXT_STYLE = TextStyle(
    color: Colors.green,
//    fontFamily: 'SourceCodePro-Bold',
//    fontFamily: 'CourierPrime-Bold',
    height: 1
);


const int DEFAULT_FONT_SIZE = 15;
const LEADING_CHARACTERS = 5;
const TAIL_CHARACTERS = 5;

const STREAM_GENERATION_INTERVAL = 4;

final List<GradientColor> LEADING_GRADIENT_COLORS = List()
  ..add(GradientColor(Colors.black.withAlpha(0), 0))
  ..add(GradientColor(Colors.green, 1));
final List<GradientColor> TAIL_GRADIENT_COLORS = List()
  ..add(GradientColor(Colors.green, 0))
  ..add(GradientColor(Colors.white, 1));


final randomSeed = Random(DateTime.now().millisecondsSinceEpoch);

final Map<String, TextPainter> TEXT_PAINTERS = Map();
bool _isPaintersBuilt = false;

void buildTextPainters() {
  if (_isPaintersBuilt) {
    return;
  }

  final start = DateTime.now().millisecondsSinceEpoch;
  Logger.debug('build text painters...');

  List<Color> leadingColors = calculateGradientColors(
      LEADING_CHARACTERS, LEADING_GRADIENT_COLORS);
  List<Color> tailColors = calculateGradientColors(
      TAIL_CHARACTERS, TAIL_GRADIENT_COLORS);

  for (int cIndex = 0; cIndex < CHARSET.length; cIndex++) {
    for (int fontSize = 1; fontSize <= DEFAULT_FONT_SIZE; fontSize++) {
      for (int lIndex = 0; lIndex < LEADING_CHARACTERS; lIndex++) {
        String key = "${CHARSET[cIndex]}.L$lIndex.$fontSize";
//        Logger.debug('generating painter for: $key, color: ${leadingColors[lIndex]}');

        TEXT_PAINTERS[key] = _createPainter(
            CHARSET[cIndex], leadingColors[lIndex], fontSize);
      }

      for (int tIndex = 0; tIndex < TAIL_CHARACTERS; tIndex++) {
        String key = "${CHARSET[cIndex]}.T$tIndex.$fontSize";
//        Logger.debug('generating painter for: $key, color: ${tailColors[tIndex]}');

        TEXT_PAINTERS[key] = _createPainter(
            CHARSET[cIndex], tailColors[tIndex], fontSize);
      }

      String key = "${CHARSET[cIndex]}.B.$fontSize";
//      Logger.debug('generating painter for: $key');

      TEXT_PAINTERS[key] = _createPainter(
          CHARSET[cIndex], Colors.green, fontSize);
    }
  }

  final end = DateTime.now().millisecondsSinceEpoch;
  Logger.debug('build text painters is accomplished in ${end - start} millis.');

  _isPaintersBuilt = true;
}

TextPainter _createPainter(String text, Color color, int fontSize) {
  final textStyle = TextStyle(
      color: color,
      fontSize: fontSize.toDouble()
  );

  final textSpan = TextSpan(
    text: text,
    style: textStyle,
  );

  final painter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );

  painter.layout();

  return painter;
}

String randomString(int len) {
  String result = "";

  for (int i = 0; i < len; i++) {
    int index = randomSeed.nextInt(CHARSET.length);
    result += CHARSET[index];
  }

  return result;
}

Size measureChars(String chars, TextStyle textStyle) {
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

class GradientColor {

  final Color color;
  final double percentage;

  GradientColor(this.color, this.percentage);

}

List<Color> calculateGradientColors(int len, List<GradientColor> targetColors) {
  List<Color> outputColors = List();

  if (len <= 0 || targetColors.length <= 0) {
    return outputColors;
  }

  GradientColor from;
  GradientColor to;
  for (int i = 0; i < targetColors.length - 1; i++) {
    from = _getFromGradientColor(i, targetColors);
    to = _getToGradientColor(i + 1, targetColors);

    int count = ((to.percentage - from.percentage) * len).ceil();
    for (int j = 0; j < count; j++) {
      Color color = getGradientColor(from.color, to.color, (j / count.toDouble()));

      outputColors.add(color);
    }
  }

  if (outputColors.length < len) {
    for (int i; i < (len - outputColors.length); i++) {
      outputColors.add(to.color);
    }
  }

  return outputColors;
}


Color getGradientColor(Color from, Color to, double percentage) {
  return Color.fromARGB(from.alpha + ((to.alpha - from.alpha) * percentage).round(),
      from.red + ((to.red - from.red) * percentage).round(),
      from.green + ((to.green - from.green) * percentage).round(),
      from.blue + ((to.blue - from.blue) * percentage).round());
}

GradientColor _getFromGradientColor(int index, List<GradientColor> colors) {
  return _getGradientColor(index, colors, Colors.green, 0);
}


GradientColor _getToGradientColor(int index, List<GradientColor> colors) {
  return _getGradientColor(index, colors, Colors.black, 1);
}


GradientColor _getGradientColor(int index,
    List<GradientColor> colors,
    Color fallbackColor,
    double fallbackPercentage) {
  if (index < 0 || index >= colors.length) {
    return GradientColor(fallbackColor, fallbackPercentage);
  }

  return colors[index];
}
