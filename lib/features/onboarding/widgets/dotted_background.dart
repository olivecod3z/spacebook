import 'package:flutter/material.dart';

class DottedBackground extends StatelessWidget {
  final Widget child;
  const DottedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotGridPainter(),
      child: child,
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double spacing = 28; // increase this for more gap between dots
    const double dotRadius = 1.2;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        final paint = Paint()
          ..color = const Color(0xFFD0D5DD).withOpacity(0.55)
          ..strokeCap = StrokeCap.round;

        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
