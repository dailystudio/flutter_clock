import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:digital_clock/development/logger.dart';
import 'matrix_painter.dart';


const ASSETS = [
  "assets/images/baseline_speaker_black_48.jpg",
  "assets/images/background.jpg"
];

class MatrixViewer extends StatefulWidget {

  final String time;

  MatrixViewer({
    Key key,
    this.time,
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

  Future<Map<String, ui.Image>> _future;

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

    _future = _loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFutureBuilder();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  FutureBuilder<Map<String, ui.Image>> _buildFutureBuilder() {
    return FutureBuilder<Map<String, ui.Image>>(
      future: _future,
      builder: (context, AsyncSnapshot<Map<String, ui.Image>> snapshot) {
        return CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: MatrixPainter(widget.time, _count, _loop, snapshot.data),
        );
      },
    );
  }

  Future<Map<String, ui.Image>> _loadAssets() async {
    Map<String, ui.Image> images = Map();

    for (var asset in ASSETS) {
      images[basenameWithoutExtension(asset)] = await _loadAsset(asset);
    }

    return images;
  }

  Future<ui.Image> _loadAsset(String asset) async {
    Logger.debug('loading asset: $asset');
    final ByteData data = await rootBundle.load(asset);

    return _loadImage(new Uint8List.view(data.buffer));
  }

  Future<ui.Image> _loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }
}