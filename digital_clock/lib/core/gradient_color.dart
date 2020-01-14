import 'package:flutter/material.dart';

class GradientColor {
  final Color color;
  final double percentage;

  GradientColor(this.color, this.percentage);
}

List<Color> calculateGradientColors(int len, List<GradientColor> targetColors) {
  List<Color> outputColors = List();

  if (len <= 0 || targetColors.length <= 0) {
    return outputColors;
  }

  GradientColor from;
  GradientColor to;
  for (int i = 0; i < targetColors.length - 1; i++) {
    from = _getFromGradientColor(i, targetColors);
    to = _getToGradientColor(i + 1, targetColors);

    int count = ((to.percentage - from.percentage) * len).ceil();
    for (int j = 0; j < count; j++) {
      Color color =
          getGradientColor(from.color, to.color, (j / count.toDouble()));

      outputColors.add(color);
    }
  }

  if (outputColors.length < len) {
    for (int i; i < (len - outputColors.length); i++) {
      outputColors.add(to.color);
    }
  }

  return outputColors;
}

Color getGradientColor(Color from, Color to, double percentage) {
  return Color.fromARGB(
      from.alpha + ((to.alpha - from.alpha) * percentage).round(),
      from.red + ((to.red - from.red) * percentage).round(),
      from.green + ((to.green - from.green) * percentage).round(),
      from.blue + ((to.blue - from.blue) * percentage).round());
}

GradientColor _getFromGradientColor(int index, List<GradientColor> colors) {
  return _getGradientColor(index, colors, Colors.green, 0);
}

GradientColor _getToGradientColor(int index, List<GradientColor> colors) {
  return _getGradientColor(index, colors, Colors.black, 1);
}

GradientColor _getGradientColor(int index, List<GradientColor> colors,
    Color fallbackColor, double fallbackPercentage) {
  if (index < 0 || index >= colors.length) {
    return GradientColor(fallbackColor, fallbackPercentage);
  }

  return colors[index];
}
