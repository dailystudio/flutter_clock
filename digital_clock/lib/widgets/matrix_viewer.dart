import 'package:flutter/cupertino.dart';
import 'package:digital_clock/widgets/matrix_painter.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

class MatrixViewer extends StatefulWidget {
  final DateTime dateTime;
  final ClockModel model;

  MatrixViewer({
    Key key,
    this.dateTime,
    this.model,
  }) : super(key: key);

  @override
  _MatrixViewerState createState() => _MatrixViewerState();
}

class _MatrixViewerState extends State<MatrixViewer>
    with SingleTickerProviderStateMixin {
  double _progress = 0;
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
        controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    _animation = Tween(begin: 1.0, end: 100.0).animate(controller)
      ..addListener(() {
        setState(() {
          _progress = _animation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = widget.dateTime;

    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(dateTime);
    final minute = DateFormat('mm').format(dateTime);
    final date = DateFormat('MMMM d, yyyy').format(dateTime);
    final amOrPm =
        (widget.model.is24HourFormat ? "" : DateFormat('aaa').format(dateTime));

    String characters =
        '$date$hour$minute$amOrPm${widget.model.location}${widget.model.temperatureString}${widget.model.weatherCondition}';
    return CustomPaint(
      size: Size(double.infinity, double.infinity),
      painter: MatrixPainter(characters, _progress),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
