import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:digital_clock/development/logger.dart';
import 'package:digital_clock/common/constants.dart';
import 'package:digital_clock/core/clock_digits.dart';
import 'package:digital_clock/core/clock_face_painter.dart';
import 'package:digital_clock/core/text_stream.dart';

const COLORS = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.pink
];

class PebblePainter extends CustomPainter {

  final ui.Image background;
  final ui.Image pebble;

  Rect _renderRect;

  Size _pebbleSize;
  int _cols = 50;
  int _rows = 30;

  PebblePainter(this.background, this.pebble);

  @override
  void paint(Canvas canvas, Size size) {
//    canvas.drawColor(Colors.black, BlendMode.src);

    _layout(size);
    _drawBackgroundCover(canvas, size);
    _drawPebbles(canvas, size);
  }

  void _layout(Size size) {
    Size imageSize = Size(
        background.width.toDouble(),
        background.height.toDouble()
    );

    Logger.debug('image: $imageSize, aspect: ${imageSize.width / imageSize.height}');
    Logger.debug('canvas: $size, aspect: ${size.width / size.height}');

    double scale = _calculateScale(imageSize, size);
    Logger.debug("painting scale ... [$scale]");

    double destWidth = background.width * scale;
    double destHeight = background.height * scale;
    double offsetX = (size.width - destWidth) / 2.0;
    double offsetY = (size.height - destHeight) / 2.0;
    Logger.debug("painting dest ... w = $destWidth, h = $destHeight");
    Logger.debug("painting offset ... x = $offsetX, y = $offsetY");

    _renderRect = Rect.fromLTWH(offsetX, offsetY, destWidth, destHeight);
    _pebbleSize = Size(
        _renderRect.width / _cols,
        _renderRect.height / _rows
    );
  }

  void _drawPebbles(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint..style = PaintingStyle.fill;
//    paint..colorFilter = ColorFilter.mode(
//        COLORS[randomSeed.nextInt(COLORS.length)],
//        BlendMode.dstOver
//    );
    Rect srcRect = Rect.fromLTWH(0, 0, pebble.width.toDouble(), pebble.height.toDouble());

    Rect dstRect;
    for (int r = 0; r < _rows; r++) {
      for (int c = 0; c < _cols; c++) {
        paint..color = COLORS[randomSeed.nextInt(COLORS.length)];
        dstRect = Rect.fromLTWH(
            _renderRect.left + c * _pebbleSize.width,
            _renderRect.top + r * _pebbleSize.height,
            _pebbleSize.width,
            _pebbleSize.height,
        );

        canvas.drawImageRect(pebble, srcRect, dstRect, paint);
//        canvas.drawCircle(dstRect.center, max(dstRect.width, dstRect.height) / 2, paint);
      }
    }
  }

  void _drawBackgroundCover(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint..color = Colors.green;
    paint..style = PaintingStyle.fill;
//    paint..colorFilter = ColorFilter.mode(Colors.green, BlendMode.srcATop);
//    paint..strokeWidth = 3;

    Rect srcRect = Rect.fromLTWH(0, 0, background.width.toDouble(), background.height.toDouble());

    canvas.drawImageRect(background, srcRect, _renderRect, paint);
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as PebblePainter).background != background;
  }

}