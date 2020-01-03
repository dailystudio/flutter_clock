import 'package:flutter/cupertino.dart';
import 'package:digital_clock/development/logger.dart';
import 'package:digital_clock/widgets/matrix_painter.dart';
import 'package:flutter_clock_helper/model.dart';

class MatrixViewer extends StatefulWidget {

  final ClockModel model;

  MatrixViewer({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  _MatrixViewerState createState() => _MatrixViewerState();
}

class _MatrixViewerState extends State<MatrixViewer>
    with SingleTickerProviderStateMixin {

  int _loop = 0;
  double _count =  0;
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

    _animation = Tween(begin: 1.0, end: 100.0).animate(controller)
      ..addListener(() {
        setState(() {
          _count = _animation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, double.infinity),
      painter: MatrixPainter(_count, _loop),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}