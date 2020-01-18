import 'dart:math';

import 'package:digital_clock/common/constants.dart';
import 'package:digital_clock/development/logger.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPainter extends CustomPainter {

  final img.Image image;

  Map<String, TextPainter> _bitsPainters = Map();

  EventPainter(this.image) {
    Constants.buildTextPainters();
  }

  @override
  void paint(Canvas canvas, Size size) {
    _performPainting(canvas, size);
  }

  void _performPainting(Canvas canvas, Size size) {
    if (image == null) {
      return;
    }
    Size cellSize = _calCellSize(size);
    int fontSize = (min(cellSize.width, cellSize.height) * 1.2).round();

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        if (image.getPixel(x, y) == 0) {
          TextPainter tp;

          if (Constants.randomSeed.nextInt(15) == 1) {
            _bitsPainters.remove("$x.$y");
          }

          if (_bitsPainters.containsKey("$x.$y")) {
            tp = _bitsPainters["$x.$y"];
          } else {
            int index = Constants.randomSeed.nextInt(Constants.charSets.length);
            int type = Constants.randomSeed.nextInt(3);

            String key;

            switch (type) {
              case 0:
                key = '${Constants.charSets[index]}.B.$fontSize';
                break;
              case 1:
                key = '${Constants.charSets[index]}.T2.$fontSize';
                break;
              case 2:
                key = '${Constants.charSets[index]}.L3.$fontSize';
                break;
            }

            tp = Constants.textPainters[key];
            if (tp == null) {
              Logger.warn("[$x.$y]: tp for $key does NOT exist.");
            }

            _bitsPainters["$x.$y"] = tp;
          }

          if (tp != null) {
            tp.paint(canvas,
                Offset(x * cellSize.width, y * cellSize.height));
          }
        }
      }
    }
  }

  Size _calCellSize(Size canvasSize) {
    return Size(canvasSize.width / image.width,
        canvasSize.height / image.height);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
