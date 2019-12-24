import 'package:digital_clock/development/logger.dart';
import 'package:digital_clock/widgets/charaters_painter.dart';
import 'package:flutter/cupertino.dart';

import 'matrix_painter.dart';

class CharactersViewer extends StatefulWidget {

  final String characters;

  CharactersViewer({
    Key key,
    this.characters,
  }) : super(key: key);

  @override
  _CharactersViewerState createState() => _CharactersViewerState();
}

class _CharactersViewerState extends State<CharactersViewer>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, double.infinity),
      painter: CharactersPainter(widget.characters),
    );
  }

}