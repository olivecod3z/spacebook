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
    const double spacing = 28;
    const double dotRadius = 1.2;
    final double fadeEnd = size.height * 0.45;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < fadeEnd; y += spacing) {
        // Gradually reduce opacity as y approaches fadeEnd
        final double progress = y / fadeEnd;
        final double opacity = (1.0 - progress) * 1;

        final paint = Paint()
          ..color = const Color(0xFFD0D5DD).withOpacity(opacity)
          ..strokeCap = StrokeCap.round;

        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
