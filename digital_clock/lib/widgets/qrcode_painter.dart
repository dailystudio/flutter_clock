import 'dart:math';

import 'package:digital_clock/development/logger.dart';
import 'package:flutter/material.dart';
import 'package:digital_clock/common/constants.dart';
import 'package:qr/qr.dart';

class QRCodePainter extends CustomPainter {

  final String text;

  QrCode _qrCode;

  Map<String, TextPainter> _qrCodePainters = Map();

  QRCodePainter(this.text) {
    _qrCode = new QrCode(5, QrErrorCorrectLevel.L);
    _qrCode.addData(text);
    _qrCode.make();
  }

  @override
  void paint(Canvas canvas, Size size) {
    Size cellSize = _calculateCell(size);
    int fontSize = (min(cellSize.width, cellSize.height) * 1.2).round();

//    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    for (int x = 0; x < _qrCode.moduleCount; x++) {
      for (int y = 0; y < _qrCode.moduleCount; y++) {
        if (_qrCode.isDark(y, x)) {
          TextPainter tp;

          if (true) {
//          if (Constants.randomSeed.nextInt(4) % 2 == 0) {
            _qrCodePainters.remove("$x.$y");
          }

          if (_qrCodePainters.containsKey("$x.$y")) {
            tp = _qrCodePainters["$x.$y"];
          } else {
            int index = Constants.randomSeed.nextInt(Constants.charSets.length);
            tp = Constants.textPainters['${Constants.charSets[index]}.B.$fontSize'];

            _qrCodePainters["$x.$y"] = tp;
          }

          tp.paint(canvas,
              Offset(x * cellSize.width, y * cellSize.height));
//          canvas.drawRect(Rect.fromLTWH(
//              x * cellSize.width,
//              y * cellSize.height,
//              cellSize.width, cellSize.height), paint);
        }
      }
    }
  }

  Size _calculateCell(Size canvasSize) {
    double cellWidth = canvasSize.width / _qrCode.moduleCount;
    double cellHeight = canvasSize.height / _qrCode.moduleCount;

    return Size(cellWidth, cellHeight);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as QRCodePainter).text != this.text;
  }
}
