import 'package:flutter/material.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';

class Hollow extends StatelessWidget {
  const Hollow({
    super.key,
    required this.isStroke,
  });

  final bool isStroke;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      height: 12,
      child: CustomPaint(
        painter: _CirclePainter(isStroke: isStroke),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  const _CirclePainter({
    required this.isStroke,
  });

  final bool isStroke;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = ColorName.blue // Circle color
      ..style = isStroke
          ? PaintingStyle.stroke
          : PaintingStyle.fill // Draw only the outline of the circle
      ..strokeWidth = 1.5; // Width of the circle outline

    // Draw the circle
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
