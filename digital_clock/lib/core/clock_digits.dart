import 'dart:math';
import 'dart:ui' as ui;
import 'package:digital_clock/core/text_stream.dart';
import 'package:digital_clock/development/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_clock/common/constants.dart';

const DEFAULT_COLS = 25;
const DEFAULT_ROWS = 15;
const START_COLS = 4;
const START_ROWS = 5;
const DIGITS = 5;
const DIGIT_COLS = 4;

final List<Point> DIGIT_0 = List()
  ..add(Point(0, 0))
//  ..add(Point(0, 1))
  ..add(Point(0, 2))
//  ..add(Point(0, 3))
  ..add(Point(0, 4))
//  ..add(Point(1, 4))
  ..add(Point(2, 4))
//  ..add(Point(2, 3))
  ..add(Point(2, 2))
//  ..add(Point(2, 1))
  ..add(Point(2, 0));
//  ..add(Point(1, 0));


final List<Point> DIGIT_1 = List()
  ..add(Point(1, 0))
//  ..add(Point(1, 1))
  ..add(Point(1, 2))
//  ..add(Point(1, 3))
  ..add(Point(1, 4));

final List<Point> DIGIT_2 = List()
  ..add(Point(0, 0))
//  ..add(Point(1, 0))
  ..add(Point(2, 0))
//  ..add(Point(2, 1))
  ..add(Point(2, 2))
//  ..add(Point(1, 2))
  ..add(Point(0, 2))
//  ..add(Point(0, 3))
  ..add(Point(0, 4))
//  ..add(Point(1, 4))
  ..add(Point(2, 4));

final List<Point> DIGIT_3 = List()
  ..add(Point(0, 0))
  ..add(Point(1, 0))
  ..add(Point(2, 0))
  ..add(Point(2, 1))
  ..add(Point(2, 2))
  ..add(Point(1, 2))
  ..add(Point(0, 2))
  ..add(Point(2, 3))
  ..add(Point(0, 4))
  ..add(Point(1, 4))
  ..add(Point(2, 4));

final List<Point> DIGIT_4 = List()
  ..add(Point(0, 0))
//  ..add(Point(0, 1))
  ..add(Point(0, 2))
//  ..add(Point(1, 2))
  ..add(Point(2, 0))
//  ..add(Point(2, 1))
  ..add(Point(2, 2))
//  ..add(Point(2, 3))
  ..add(Point(2, 4));

final List<Point> DIGIT_5 = List()
  ..add(Point(0, 0))
  ..add(Point(1, 0))
  ..add(Point(2, 0))
  ..add(Point(0, 1))
  ..add(Point(2, 2))
  ..add(Point(1, 2))
  ..add(Point(0, 2))
  ..add(Point(2, 3))
  ..add(Point(0, 4))
  ..add(Point(1, 4))
  ..add(Point(2, 4));

final List<Point> DIGIT_6 = List()
  ..add(Point(0, 0))
  ..add(Point(1, 0))
  ..add(Point(2, 0))
  ..add(Point(0, 1))
  ..add(Point(2, 2))
  ..add(Point(1, 2))
  ..add(Point(0, 2))
  ..add(Point(0, 3))
  ..add(Point(2, 3))
  ..add(Point(0, 4))
  ..add(Point(1, 4))
  ..add(Point(2, 4));

final List<Point> DIGIT_7 = List()
  ..add(Point(0, 0))
  ..add(Point(1, 0))
  ..add(Point(2, 0))
  ..add(Point(2, 1))
  ..add(Point(2, 2))
  ..add(Point(2, 3))
  ..add(Point(2, 4));

final List<Point> DIGIT_8 = List()
  ..add(Point(0, 0))
  ..add(Point(1, 0))
  ..add(Point(2, 0))
  ..add(Point(0, 1))
  ..add(Point(2, 1))
  ..add(Point(2, 2))
  ..add(Point(1, 2))
  ..add(Point(0, 2))
  ..add(Point(0, 3))
  ..add(Point(2, 3))
  ..add(Point(0, 4))
  ..add(Point(1, 4))
  ..add(Point(2, 4));

final List<Point> DIGIT_9 = List()
  ..add(Point(0, 0))
  ..add(Point(1, 0))
  ..add(Point(2, 0))
  ..add(Point(0, 1))
  ..add(Point(2, 1))
  ..add(Point(2, 2))
  ..add(Point(1, 2))
  ..add(Point(0, 2))
  ..add(Point(2, 3))
  ..add(Point(0, 4))
  ..add(Point(1, 4))
  ..add(Point(2, 4));

final List<Point> DIGIT_COLON = List()
  ..add(Point(1, 1))
  ..add(Point(1, 3));


final Map<String, List<Point>> DIGITS_MATRIX = Map();
final List<int> DIGITS_COLS = List()
  ..add(4)
  ..add(3)
  ..add(3)
  ..add(4)
  ..add(3);

class DigitStream {

  final int id;
  final Rect boundary;
  bool exists = false;

  DigitStream(this.id, this.boundary);

}

class ClockDigits {

  static String _characters;

  int rows = DEFAULT_ROWS;
  int cols = DEFAULT_COLS;

  int _cellWidth = 1;
  int _cellHeight = 1;

  int minCol = DEFAULT_COLS;
  int maxCol = 0;
  int minRow = DEFAULT_ROWS;
  int maxRow = 0;

  List<Point> _filledGrids = List();
  static Rect _boundary = Rect.fromLTRB(0, 0, 0, 0);
  static bool _isBoundaryCalculated = false;
  static Map<String, DigitStream> _digitStreams = Map();
  static double increment = 0;

  Map<String, ui.Image> _assets;

  ClockDigits(String characters, Map<String, ui.Image> assets) {
//    Logger.debug('_characters = $_characters, characters = $characters');

    if (_characters != characters) {
      Logger.debug('reset increment');
      increment = 0;
    }
    _characters = characters;
    _assets = assets;

    Logger.debug('assets: $assets');

    if (DIGITS_MATRIX.length <= 0) {
      DIGITS_MATRIX["0"] = DIGIT_0;
      DIGITS_MATRIX["1"] = DIGIT_1;
      DIGITS_MATRIX["2"] = DIGIT_2;
      DIGITS_MATRIX["3"] = DIGIT_3;
      DIGITS_MATRIX["4"] = DIGIT_4;
      DIGITS_MATRIX["5"] = DIGIT_5;
      DIGITS_MATRIX["6"] = DIGIT_6;
      DIGITS_MATRIX["7"] = DIGIT_7;
      DIGITS_MATRIX["8"] = DIGIT_8;
      DIGITS_MATRIX["9"] = DIGIT_9;
      DIGITS_MATRIX[":"] = DIGIT_COLON;
    }

    _initDigits();
  }

  void _initDigits() {
    if (_characters.length != DIGITS) {
      Logger.warn("incorrect digits format: HH:MM");

      return;
    }

    int startCols = START_COLS;
    int startRows = START_ROWS;
    for (int i = 0; i < DIGITS; i++) {
      var matrix = DIGITS_MATRIX[_characters[i]];

      for (var p in matrix) {
        _filledGrids.add(Point(p.x + startCols, startRows + p.y));
      }

      _filledGrids.add(Point(-1, -1));

      startCols += DIGITS_COLS[i];
    }

    _isBoundaryCalculated = false;
  }

  void layout(Size size) {
    _calculateBoundaries(size);
  }

  void paint(Canvas canvas, Size size) {
//    _drawGrids(canvas, size);
    _drawTimeMatrix(canvas, size);
//    _drawImageInc(canvas, size);
  }

  void _drawImageInc(Canvas canvas, Size size) {
    if (_assets == null) {
      return;
    }

    Paint paint = Paint();
    paint..color = Colors.green;
    paint..style = PaintingStyle.fill;
//    paint..colorFilter = ColorFilter.mode(Colors.green, BlendMode.srcATop);
//    paint..strokeWidth = 3;

    ui.Image image = _assets['background'];

    Size imageSize = Size(
        image.width.toDouble(),
        image.height.toDouble()
    );

    Logger.debug('image: $imageSize, aspect: ${imageSize.width / imageSize.height}');
    Logger.debug('canvas: $size, aspect: ${size.width / size.height}');

    double scale = _calculateScale(imageSize, size);
    Logger.debug("painting scale ... [$scale]");

    double destWidth = image.width * scale;
    double destHeight = image.height * scale;
    double offsetX = (size.width - destWidth) / 2.0;
    double offsetY = (size.height - destHeight) / 2.0;
    Logger.debug("painting dest ... w = $destWidth, h = $destHeight");
    Logger.debug("painting offset ... x = $offsetX, y = $offsetY");

    double proportion = (100 - increment) / 100.toDouble();
    double srcYOffset = image.height * proportion;
    double srcIncHeight = image.height * (1 - proportion);
    double dstYOffset = destHeight * proportion;
    double dstIncHeight = destHeight * (1 - proportion);
    Logger.debug("increment ...increment = $increment");
    Logger.debug("increment ...proportion = $proportion");
    Logger.debug("increment ...srcYOffset = $srcYOffset");
    Logger.debug("increment ...srcIncHeight = $srcIncHeight");
    Logger.debug("increment ...dstYOffset = $dstYOffset");
    Logger.debug("increment ...dstIncHeight = $dstIncHeight");

    Rect srcRect = Rect.fromLTWH(0, srcYOffset, image.width.toDouble(), srcIncHeight);
    Rect dstRect = Rect.fromLTWH(offsetX, offsetY + dstYOffset, destWidth, dstIncHeight);

    canvas.drawImageRect(image, srcRect, dstRect, paint);

    if (increment < 100) {
      increment += 0.1;
    }
  }

  void _drawTimeMatrix(Canvas canvas, Size size) {
    if (_assets == null) {
      return;
    }


    Paint paint = Paint();
    paint..color = Colors.green;
    paint..style = PaintingStyle.fill;
    paint..colorFilter = ColorFilter.mode(Colors.green, BlendMode.srcATop);
    paint..strokeWidth = 3;
//    paint..maskFilter = MaskFilter.blur(BlurStyle.inner, 10.0);

    ui.Image image = _assets['baseline_speaker_black_48'];
    Rect srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    Rect r;
    Rect lastRect;
    for (var p in _filledGrids) {
      if (p.x == -1 && p.y == -1) {
        lastRect = null;
        continue;
      }
      r = Rect.fromLTWH(p.x * _cellWidth.toDouble(), p.y * _cellHeight.toDouble(),
          _cellWidth.toDouble(), _cellHeight.toDouble());

      canvas.drawImageRect(image, srcRect, r, paint);

      if (lastRect != null) {
        canvas.drawLine(lastRect.center, r.center, paint);
      }

      lastRect = r;
//      canvas.drawRect(r, occupiedPaint);
    }
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


  double _calculateScale(Size srcSize, Size destSize) {
    if (srcSize == null || destSize == null) {
      return 1.0;
    }

    double iRatio = srcSize.width / srcSize.height;
    double cRatio = destSize.width / destSize.height;

    double ratio = 1.0;
    if (iRatio > cRatio) {
      ratio = destSize.height / srcSize.height;
    } else {
      ratio = destSize.width / srcSize.width;
    }

    return ratio;
  }

}
