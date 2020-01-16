import 'package:digital_clock/widgets/qrcode_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class QRCodePresenter extends StatefulWidget {
  final ClockModel model;

  QRCodePresenter({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  _QRCodePresenterState createState() => _QRCodePresenterState();
}

class _QRCodePresenterState extends State<QRCodePresenter> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(180, 180),
      painter: QRCodePainter("https://robot.orangelabschina.cn:1038/?p=20200116181900|Mountain View, CA|22.0|sunny"),
    );
  }
}
