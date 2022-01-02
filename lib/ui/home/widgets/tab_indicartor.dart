import 'package:flutter/material.dart';

class TabIndicator extends Decoration {
  final BoxPainter _painter;

  TabIndicator(Color color) : _painter = _LinePainter(color);

  @override
  BoxPainter createBoxPainter([Function()? onChanged]) => _painter;
}

class _LinePainter extends BoxPainter {
  final Paint _paint;

  _LinePainter(Color color)
      : _paint = Paint()
          ..color = color
          ..strokeWidth = 3;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    canvas.drawLine(offset + Offset(cfg.size!.width * 2 / 5, cfg.size!.height * 1),
        offset + Offset(cfg.size!.width * 3 / 5, cfg.size!.height * 1), _paint);
  }
}
