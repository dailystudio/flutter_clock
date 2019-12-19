import 'package:digital_clock/development/logger.dart';
import 'package:flutter/cupertino.dart';

import 'matrix_painter.dart';

class MatrixViewer extends StatefulWidget {
  @override
  _MatrixViewerState createState() => _MatrixViewerState();
}

class _MatrixViewerState extends State<MatrixViewer>
    with SingleTickerProviderStateMixin {

  int _loop = 0;
  double _position =  0;
  Animation<double> _animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: 60000), vsync: this);

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Logger.debug('loop: $_loop');
        controller.reset();
        _loop++;
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween(begin: -100.0, end: 500.0).animate(controller)
      ..addListener(() {
        setState(() {
          _position = _animation.value;
        });
      });


    return CustomPaint(
      size: Size(double.infinity, double.infinity),
      painter: MatrixPainter(_position, _loop),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}