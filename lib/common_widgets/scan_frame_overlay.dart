import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Dimmed overlay with a transparent rounded scan window and corner marks.
class ScanFrameOverlay extends StatelessWidget {
  const ScanFrameOverlay({super.key, required this.frameSize});

  final double frameSize;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _FramePainter(frameSize),
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  _FramePainter(this.frame);

  final double frame;
  static const double _radius = 24;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: frame,
      height: frame,
    );

    final dim = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()
        ..addRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(_radius))),
    );
    canvas.drawPath(dim, Paint()..color = AppColors.scrim);

    final l = rect.left, t = rect.top, r = rect.right, b = rect.bottom;
    final len = frame * 0.18;
    const rad = _radius;
    final path = Path()
      ..moveTo(l, t + len)
      ..lineTo(l, t + rad)
      ..arcTo(
          Rect.fromLTWH(l, t, rad * 2, rad * 2), math.pi, math.pi / 2, false)
      ..lineTo(l + len, t)
      ..moveTo(r - len, t)
      ..lineTo(r - rad, t)
      ..arcTo(Rect.fromLTWH(r - rad * 2, t, rad * 2, rad * 2), -math.pi / 2,
          math.pi / 2, false)
      ..lineTo(r, t + len)
      ..moveTo(r, b - len)
      ..lineTo(r, b - rad)
      ..arcTo(Rect.fromLTWH(r - rad * 2, b - rad * 2, rad * 2, rad * 2), 0,
          math.pi / 2, false)
      ..lineTo(r - len, b)
      ..moveTo(l + len, b)
      ..lineTo(l + rad, b)
      ..arcTo(Rect.fromLTWH(l, b - rad * 2, rad * 2, rad * 2), math.pi / 2,
          math.pi / 2, false)
      ..lineTo(l, b - len);

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _FramePainter old) => old.frame != frame;
}
