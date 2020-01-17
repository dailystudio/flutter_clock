import 'dart:async';
import 'dart:typed_data';

import 'package:digital_clock/development/logger.dart';
import 'package:digital_clock/widgets/event_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/services.dart';

class ImageViewer extends StatefulWidget {
  final String imageFile;

  ImageViewer({
    Key key,
    this.imageFile,
  }) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  var _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _loadFromAsset(widget.imageFile);
  }

  Future<img.Image> _loadFromAsset(String frameFile) async {
    Logger.debug("loading image from assets ... [$frameFile]");

    ByteData data = await rootBundle.load(frameFile);

    Uint8List bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    img.Image image = img.decodeImage(bytes);

    return image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }

          return CustomPaint(
            painter: ImagePainter(snapshot.data),
          );
        });
  }
}
