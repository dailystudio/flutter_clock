import 'dart:math';

import 'dart:ui';

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

final randomSeed = Random(DateTime.now().millisecondsSinceEpoch);


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
    to = _getFromGradientColor(i + 1, targetColors);

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
  return Color.fromARGB(255,
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
