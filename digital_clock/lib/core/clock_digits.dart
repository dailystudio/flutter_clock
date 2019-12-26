import 'dart:math';

import 'package:digital_clock/core/text_stream.dart';
import 'package:digital_clock/development/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_clock/common/constants.dart';

const DEFAULT_ROWS = 50;
const DEFAULT_COLS = 30;

class DigitStream {

  final int id;
  final Rect boundary;
  bool exists = false;

  DigitStream(this.id, this.boundary);

}

class ClockDigits {

  String _characters;

  int rows = DEFAULT_ROWS;
  int cols = DEFAULT_COLS;

  int _cellWidth = 1;
  int _cellHeight = 1;
  int _colsPerCell = 1;

  int minCol = DEFAULT_COLS;
  int maxCol = 0;
  int minRow = DEFAULT_ROWS;
  int maxRow = 0;

  static List<Point> _digits = List();
  static Set<String> _digitsMap = Set();
  static Rect _boundary = Rect.fromLTRB(0, 0, 0, 0);
  static bool _isBoundaryCalculated = false;
  static Map<String, DigitStream> _digitStreams = Map();

  ClockDigits(String characters) {
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

    _isBoundaryCalculated = false;
  }

  void layout(Size size) {
    _calculateBoundaries(size);
  }

  void paint(Canvas canvas, Size size) {
//    _drawGrids(canvas, size);


    Paint occupiedPaint = Paint();
    occupiedPaint..color = Colors.white.withAlpha(128);
    occupiedPaint..style = PaintingStyle.fill;

    Rect r;
    for (var p in _digits) {
      r = Rect.fromLTWH(p.x * _cellWidth.toDouble(), p.y * _cellHeight.toDouble(),
          _cellWidth.toDouble(), _cellHeight.toDouble());
      canvas.drawRect(r, occupiedPaint);
    }
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

  void _calculateBoundaries(Size canvasSize) {
    if (_isBoundaryCalculated) {
      return;
    }

    _cellWidth = (canvasSize.width / cols).round();
    _cellHeight = (canvasSize.height / rows).round();

    for (var p in _digits) {
      _digitsMap.add("${p.x}_${p.y}");

      if (p.x < minCol) {
        minCol = p.x;
      } else if (p.x > maxCol) {
        maxCol = p.x;
      }

      if (p.y < minRow) {
        minRow = p.y;
      } else if (p.y > maxRow) {
        maxRow = p.y;
      }
    }

    double minX = minCol * _cellWidth.toDouble();
    double maxX = maxCol * _cellWidth.toDouble();
    double minY = minRow * _cellHeight.toDouble();
    double maxY = maxRow * _cellHeight.toDouble();
    _boundary = Rect.fromLTRB(minX, minY, maxX, maxY);

    Logger.debug("boundaries: $_digitsMap");
    Logger.debug("cols: [$minCol, $maxCol]");
    Logger.debug("rows: [$minRow, $maxRow]");

    Logger.debug("_boundary: $_boundary");

    Size size = measureChars('0', TEXT_STYLE);

    _colsPerCell = (_cellWidth / size.width).round();
    Logger.debug("_colsPerCell: $_colsPerCell");

    _digitStreams.clear();

    int id = 0;
    for (double x = minX; x <= maxX; x += size.width) {
      final Rect rect = Rect.fromLTRB(x, 0, x + size.width, canvasSize.height);
      _digitStreams["$id"] = DigitStream(id, rect);
      Logger.debug('new stream: $id, boundary = $rect}');
      id++;
    }

    _isBoundaryCalculated = true;
  }

  TextStream randomCreateTextStream() {
    for (var ds in _digitStreams.entries) {
      if (ds.value.exists == false) {
        ds.value.exists = true;
        return _generateNewStream(ds.value.id, ds.value.boundary);
      }
    }

    return null;
  }

  TextStream _generateNewStream(int id, Rect boundary) {
    int len = MAX_CHARACTERS;

    return TextStream("DS$id", randomString(len), boundary, speed: 1);
  }


  Rect getBoundary() {
    return _boundary;
  }

  bool isInBoundaries(double x, double y) {
    int row = (y / _cellHeight).round();
    int col = (x / _cellWidth).round();

    String key = "${col}_$row";

    return _digitsMap.contains(key);
  }

}
