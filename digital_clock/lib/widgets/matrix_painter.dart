import 'package:flutter/material.dart';
import 'package:digital_clock/common/constants.dart';
import 'package:digital_clock/core/text_stream.dart';

class MatrixPainter extends CustomPainter {
  static String _characters = Constants.charSets;
  double _progress = 0;
  static List<TextStream> _textStreams = List();

  MatrixPainter(String characters, double progress) {
    Constants.buildTextPainters();
    this._progress = progress;

    if (_characters != characters) {
      _textStreams.clear();
    }

    _characters = characters;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_progress.round() % Configuration.streamGenerationInterval == 0) {
      var ts;
      ts = _generateNewStream(Rect.fromLTWH(0, 0, size.width, size.height));
      _textStreams.add(ts);
    }

    paintStreams(canvas, size, _textStreams);
  }

  void paintStreams(Canvas canvas, Size size, List<TextStream> streams) {
    List<TextStream> useless = List();

    for (TextStream stream in streams) {
      final dx = stream.baseOffset.dx;
      final dy = stream.baseOffset.dy + stream.yOffset;

      stream.yOffset += stream.speed;
      stream.scaleDelta += 0.001;

      if (dy < -stream.size.height || dy > size.height) {
        if (dy > size.height) {
          useless.add(stream);
        }

        continue;
      }

      double yOffset = 0;
      for (int i = 0; i < stream.charsCount; i++) {
        TextPainter tp = stream.streamPainters[i];
        final charOffset = Offset(dx, dy + yOffset);

        if (tp != null) {
          tp.paint(canvas, charOffset);
          yOffset += tp.height;
        }
      }
    }

    for (TextStream s in useless) {
      streams.remove(s);
    }
  }

  TextStream _generateNewStream(Rect boundary) {
    int len = Configuration.minCharacters +
        Constants.randomSeed
            .nextInt(Configuration.maxCharacters - Configuration.minCharacters);

    int id = DateTime.now().millisecondsSinceEpoch;

    return TextStream(
        "C$id",
//        Constants.randomString(len, charset: _characters),
        Constants.randomString(len),
        boundary);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
