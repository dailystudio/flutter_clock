import 'dart:math';
import 'dart:ui';
import 'package:digital_clock/core/event.dart';
import 'package:digital_clock/core/gradient_color.dart';
import 'package:digital_clock/development/logger.dart';
import 'package:flutter/material.dart';

class Constants {
  static final String eventsFile = "assets/events.json";

  static final defaultEvent = Event(
      name: "default",
      imageFile: "assets/images/default.png",
      dates: [
        Date(
            start: "0101",
            end: "1231"
        )
      ]
  );

  static final randomSeed = Random(DateTime.now().millisecondsSinceEpoch);

  static final Map<String, TextPainter> textPainters = Map();
  static bool _isPaintersBuilt = false;

  static final charSets = '0123456789' +
      '°C°F, .-' +
      'abcdefghijklmnopqrstuvwxyz' +
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
//    '\u{30A0}\u{30A1}\u{30A2}\u{30A3}\u{30A4}\u{30A5}\u{30A6}\u{30A7}\u{30A8}\u{30A9}\u{30AA}\u{30AB}\u{30AC}\u{30AD}\u{30AE}\u{30AF}' +
//    '\u{30B0}\u{30B1}\u{30B2}\u{30B3}\u{30B4}\u{30B5}\u{30B6}\u{30B7}\u{30B8}\u{30B9}\u{30BA}\u{30BB}\u{30BC}\u{30BD}\u{30BE}\u{30BF}' +
//    '\u{30C0}\u{30C1}\u{30C2}\u{30C3}\u{30C4}\u{30C5}\u{30C6}\u{30C7}\u{30C8}\u{30C9}\u{30CA}\u{30CB}\u{30CC}\u{30CD}\u{30CE}\u{30CF}' +
//    '\u{30D0}\u{30D1}\u{30D2}\u{30D3}\u{30D4}\u{30D5}\u{30D6}\u{30D7}\u{30D8}\u{30D9}\u{30DA}\u{30DB}\u{30DC}\u{30DD}\u{30DE}\u{30DF}' +
//    '\u{30E0}\u{30E1}\u{30E2}\u{30E3}\u{30E4}\u{30E5}\u{30E6}\u{30E7}\u{30E8}\u{30E9}\u{30EA}\u{30EB}\u{30EC}\u{30ED}\u{30EE}\u{30EF}' +
//    '\u{30F0}\u{30F1}\u{30F2}\u{30F3}\u{30F4}\u{30F5}\u{30F6}\u{30F7}\u{30F8}\u{30F9}\u{30FA}\u{30FB}\u{30FC}\u{30FD}\u{30FE}\u{30FF}' +
      '';

  static final _defaultTextStyle = TextStyle(color: Colors.green, height: 1);

  static TextPainter _createPainter(String text, Color color, int fontSize) {
    final textStyle =
        _defaultTextStyle.copyWith(color: color, fontSize: fontSize.toDouble());

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

  static void buildTextPainters() {
    if (_isPaintersBuilt) {
      return;
    }

    final start = DateTime.now().millisecondsSinceEpoch;
    Logger.debug('building text painters...');

    List<Color> leadingColors = calculateGradientColors(
        Configuration.leadingCharacters, Configuration.leadingGradientColors);
    List<Color> tailColors = calculateGradientColors(
        Configuration.tailCharacters, Configuration.tailGradientColors);

    for (int cIndex = 0; cIndex < charSets.length; cIndex++) {
      for (int fontSize = 1;
          fontSize <= Configuration.maxFontSize;
          fontSize++) {
        for (int lIndex = 0;
            lIndex < Configuration.leadingCharacters;
            lIndex++) {
          String key = "${charSets[cIndex]}.L$lIndex.$fontSize";

          textPainters[key] =
              _createPainter(charSets[cIndex], leadingColors[lIndex], fontSize);
        }

        for (int tIndex = 0; tIndex < Configuration.tailCharacters; tIndex++) {
          String key = "${charSets[cIndex]}.T$tIndex.$fontSize";

          textPainters[key] =
              _createPainter(charSets[cIndex], tailColors[tIndex], fontSize);
        }

        String key = "${charSets[cIndex]}.B.$fontSize";

        textPainters[key] =
            _createPainter(charSets[cIndex], Colors.green, fontSize);
      }
    }

    final end = DateTime.now().millisecondsSinceEpoch;
    Logger.debug(
        'building text painters is accomplished in ${end - start} millis.');

    _isPaintersBuilt = true;
  }

  static String randomString(int len, {charset}) {
    String result = "";

    if (charset == null) {
      charset = charSets;
    }

    for (int i = 0; i < len; i++) {
      int index = randomSeed.nextInt(charset.length);
      result += charset[index];
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
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);

    painter.layout(
      minWidth: 0,
      maxWidth: 0,
    );

    return Size(painter.minIntrinsicWidth, painter.height);
  }
}

class Configuration {
  static final int defaultFontSize = 28;
  static final int maxFontSize = 30;

  static final leadingCharacters = 5;
  static final tailCharacters = 5;
  static final maxCharacters = 30;
  static final minCharacters = 12;

  static final streamGenerationInterval = 5;
  static final maxStreamSpeed = 6;

  static final List<GradientColor> leadingGradientColors = List()
    ..add(GradientColor(Colors.black.withAlpha(0), 0))
    ..add(GradientColor(Colors.green, 1));
  static final List<GradientColor> tailGradientColors = List()
    ..add(GradientColor(Colors.green, 0))
    ..add(GradientColor(Colors.white, 1));
}
