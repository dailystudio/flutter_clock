import 'dart:math';

import 'package:digital_clock/development/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_clock/common/constants.dart';

const TEXT_STYLE = TextStyle(
    color: Colors.greenAccent,
    fontFamily: 'CourierPrime-Bold',
    fontSize: 60,
    height: 1
);

const DEFAULT_ROWS = 50;
const DEFAULT_COLS = 30;
const REPLACEMENT_COUNT = 4;

class PaintingInfo {

  final Offset offset;
  final String text;

  PaintingInfo(this.text, this.offset);
}

class CharactersPainter {

  String _characters;
  int _startMillis;

  int rows = DEFAULT_ROWS;
  int cols = DEFAULT_COLS;

  int _cellWidth = 1;
  int _cellHeight = 1;
  int _fontSize = DEFAULT_FONT_SIZE;

  TextStyle _textStyle = TEXT_STYLE;
  List<PaintingInfo> _paintingInfos = List();

  static List<Point> _digits = List();

  CharactersPainter(String characters) {
    _characters = characters;
    _startMillis = DateTime.now().millisecondsSinceEpoch;

    if (_digits.length <= 0) {
      _initDigits();
    }
  }

  void _initDigits() {
    Logger.debug('init digits');

    _digits.add(Point(7, 10));
    _digits.add(Point(7, 11));
    _digits.add(Point(7, 12));
    _digits.add(Point(7, 13));
    _digits.add(Point(7, 14));
    _digits.add(Point(7, 15));
    _digits.add(Point(7, 16));
    _digits.add(Point(7, 17));
    _digits.add(Point(7, 18));
    _digits.add(Point(7, 19));
    _digits.add(Point(7, 20));
    _digits.add(Point(7, 21));
    _digits.add(Point(7, 22));
    _digits.add(Point(7, 23));
    _digits.add(Point(7, 24));
    _digits.add(Point(7, 25));
    _digits.add(Point(7, 26));
    _digits.add(Point(7, 27));
    _digits.add(Point(7, 28));
    _digits.add(Point(7, 29));

    _digits.add(Point(8, 10));
    _digits.add(Point(8, 11));
    _digits.add(Point(8, 12));
    _digits.add(Point(8, 13));
    _digits.add(Point(8, 14));
    _digits.add(Point(8, 15));
    _digits.add(Point(8, 16));
    _digits.add(Point(8, 17));
    _digits.add(Point(8, 18));
    _digits.add(Point(8, 19));
    _digits.add(Point(8, 20));
    _digits.add(Point(8, 21));
    _digits.add(Point(8, 22));
    _digits.add(Point(8, 23));
    _digits.add(Point(8, 24));
    _digits.add(Point(8, 25));
    _digits.add(Point(8, 26));
    _digits.add(Point(8, 27));
    _digits.add(Point(8, 28));
    _digits.add(Point(8, 29));

    _digits.add(Point(10, 10));
    _digits.add(Point(10, 11));
    _digits.add(Point(10, 12));
    _digits.add(Point(10, 13));
    _digits.add(Point(10, 14));
    _digits.add(Point(10, 15));
    _digits.add(Point(10, 16));
    _digits.add(Point(10, 17));
    _digits.add(Point(10, 18));
    _digits.add(Point(10, 19));
    _digits.add(Point(10, 20));
    _digits.add(Point(10, 21));
    _digits.add(Point(10, 22));
    _digits.add(Point(10, 23));
    _digits.add(Point(10, 24));
    _digits.add(Point(10, 25));
    _digits.add(Point(10, 26));
    _digits.add(Point(10, 27));
    _digits.add(Point(10, 28));
    _digits.add(Point(10, 29));

    _digits.add(Point(11, 10));
    _digits.add(Point(11, 11));
    _digits.add(Point(11, 12));
    _digits.add(Point(11, 13));
    _digits.add(Point(11, 14));
    _digits.add(Point(11, 15));
    _digits.add(Point(11, 16));
    _digits.add(Point(11, 17));
    _digits.add(Point(11, 18));
    _digits.add(Point(11, 19));
    _digits.add(Point(11, 20));
    _digits.add(Point(11, 21));
    _digits.add(Point(11, 22));
    _digits.add(Point(11, 23));
    _digits.add(Point(11, 24));
    _digits.add(Point(11, 25));
    _digits.add(Point(11, 26));
    _digits.add(Point(11, 27));
    _digits.add(Point(11, 28));
    _digits.add(Point(11, 29));

    _digits.add(Point(15, 10));
    _digits.add(Point(15, 11));
    _digits.add(Point(15, 12));
    _digits.add(Point(15, 13));
    _digits.add(Point(15, 14));
    _digits.add(Point(15, 15));
    _digits.add(Point(15, 16));
    _digits.add(Point(15, 17));
    _digits.add(Point(15, 18));
    _digits.add(Point(15, 19));
    _digits.add(Point(15, 20));
    _digits.add(Point(15, 21));
    _digits.add(Point(15, 22));
    _digits.add(Point(15, 23));
    _digits.add(Point(15, 24));
    _digits.add(Point(15, 25));
    _digits.add(Point(15, 26));
    _digits.add(Point(15, 27));
    _digits.add(Point(15, 28));
    _digits.add(Point(15, 29));

    _digits.add(Point(16, 10));
    _digits.add(Point(16, 11));
    _digits.add(Point(16, 12));
    _digits.add(Point(16, 13));
    _digits.add(Point(16, 14));
    _digits.add(Point(16, 15));
    _digits.add(Point(16, 16));
    _digits.add(Point(16, 17));
    _digits.add(Point(16, 18));
    _digits.add(Point(16, 19));
    _digits.add(Point(16, 20));
    _digits.add(Point(16, 21));
    _digits.add(Point(16, 22));
    _digits.add(Point(16, 23));
    _digits.add(Point(16, 24));
    _digits.add(Point(16, 25));
    _digits.add(Point(16, 26));
    _digits.add(Point(16, 27));
    _digits.add(Point(16, 28));
    _digits.add(Point(16, 29));


    _digits.add(Point(18, 10));
    _digits.add(Point(18, 11));
    _digits.add(Point(18, 12));
    _digits.add(Point(18, 13));
    _digits.add(Point(18, 14));
    _digits.add(Point(18, 15));
    _digits.add(Point(18, 16));
    _digits.add(Point(18, 17));
    _digits.add(Point(18, 18));
    _digits.add(Point(18, 19));
    _digits.add(Point(18, 20));
    _digits.add(Point(18, 21));
    _digits.add(Point(18, 22));
    _digits.add(Point(18, 23));
    _digits.add(Point(18, 24));
    _digits.add(Point(18, 25));
    _digits.add(Point(18, 26));
    _digits.add(Point(18, 27));
    _digits.add(Point(18, 28));
    _digits.add(Point(18, 29));

    _digits.add(Point(19, 10));
    _digits.add(Point(19, 11));
    _digits.add(Point(19, 12));
    _digits.add(Point(19, 13));
    _digits.add(Point(19, 14));
    _digits.add(Point(19, 15));
    _digits.add(Point(19, 16));
    _digits.add(Point(19, 17));
    _digits.add(Point(19, 18));
    _digits.add(Point(19, 19));
    _digits.add(Point(19, 20));
    _digits.add(Point(19, 21));
    _digits.add(Point(19, 22));
    _digits.add(Point(19, 23));
    _digits.add(Point(19, 24));
    _digits.add(Point(19, 25));
    _digits.add(Point(19, 26));
    _digits.add(Point(19, 27));
    _digits.add(Point(19, 28));
    _digits.add(Point(19, 29));


    _digits.add(Point(13, 15));
    _digits.add(Point(13, 16));
    _digits.add(Point(13, 17));
    _digits.add(Point(13, 18));
    _digits.add(Point(13, 21));
    _digits.add(Point(13, 22));
    _digits.add(Point(13, 23));
    _digits.add(Point(13, 24));
  }

  void paint(Canvas canvas, Size size) {
    _calculateDimensions(size);

    _drawGrids(canvas, size);
//    _drawTextDigitByDigit(canvas, size);
  }

  void _drawGrids(Canvas canvas, Size size) {
    Logger.debug('_cellWidth = $_cellWidth, _cellHeight = $_cellHeight');
    Paint linePaint = Paint();
    linePaint..color = Colors.orange;
    linePaint..strokeWidth = 1;

    for (double x = 0; x < size.width; x += _cellWidth) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    for (double y = 0; y < size.height; y += _cellHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  void _drawTextDigitByDigit(Canvas canvas, Size size) {
    for (int i = 0; i < _digits.length; i++) {
      double xOffset = _paintingInfos[i].offset.dx;
      double yOffset = _paintingInfos[i].offset.dy;

      for (int c = 0; c < _paintingInfos[i].text.length; c++) {
        String key = "${_paintingInfos[i].text[c]}.T3.$_fontSize";
        var painter = TEXT_PAINTERS[key];

        final Offset offset = Offset(
            xOffset, yOffset
        );

        painter.paint(canvas, offset);

        xOffset += painter.minIntrinsicWidth;
      }
    }
  }

  void _drawTextDirectly(Canvas canvas, Size size) {
    final textStyle = TEXT_STYLE.copyWith(
      fontSize: _fontSize.toDouble(),
    );

    final textSpan = TextSpan(
      text: _characters,
      style: textStyle,
    );

    TextPainter painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    double offsetX = (size.width - painter.minIntrinsicWidth) / 2.0;
    double offsetY = (size.height - painter.height) / 2.0;

    painter.paint(canvas, Offset(offsetX, offsetY));
  }

  void _calculateDimensions(Size canvasSize) {
    _cellWidth = (canvasSize.width / cols).round();
    _cellHeight = (canvasSize.height / rows).round();
    _fontSize = min(_cellWidth, _cellHeight);
    _textStyle = TEXT_STYLE.copyWith(
        fontSize: _fontSize.toDouble(),
//        color: TEXT_STYLE.color.withAlpha((255 * _alpha).round())
    );

    Size size = measureChars('0', _textStyle);

    final count = (_cellWidth / size.width).floor();

    _paintingInfos.clear();

    for (int i = 0; i < _digits.length; i++) {

      Offset offset = Offset(
          _digits[i].x * _cellWidth.toDouble(),
          _digits[i].y * _cellHeight.toDouble()
      );

      PaintingInfo paintingInfo = PaintingInfo(
          randomString(count),
          offset);

      _paintingInfos.add(paintingInfo);
    }
  }

}
