// coverage:ignore-file
import 'package:flutter/material.dart';

import '../../../utils/canvas_wrapper.dart';
import 'base_chart_data.dart';

/// Base class of our painters.
class BaseChartPainter<D extends BaseChartData> {
  /// Draws some basic elements
  BaseChartPainter();

  // Paints [BaseChartData] into the provided canvas.
  void paint(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<D> holder,
  ) {}
}

/// Holds data for painting on canvas
class PaintHolder<Data extends BaseChartData> {
  /// Holds data for painting on canvas
  PaintHolder(this.data, this.targetData, this.textScale);

  /// [data] is what we need to show frame by frame (it might be changed by an animator)
  final Data data;

  /// [targetData] is the target of animation that is playing.
  final Data targetData;

  /// system [textScale]
  final double textScale;
}
