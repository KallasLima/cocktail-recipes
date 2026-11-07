import 'package:flutter/material.dart';

class DrinkArt extends StatelessWidget {
  final int index;
  const DrinkArt({super.key, required this.index});
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: [
      const Color(0xfff0e3c8),
      const Color(0xffe0e7d7),
      const Color(0xffeaddd9),
    ][index % 3],
    child: CustomPaint(painter: _DrinkPainter(index)),
  );
}

class _DrinkPainter extends CustomPainter {
  final int index;
  _DrinkPainter(this.index);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale((size.height / 180).clamp(0.0, 1.7));
    final p = Paint();
    canvas.drawOval(
      const Rect.fromLTWH(-45, 66, 90, 10),
      p..color = Colors.black.withValues(alpha: .06),
    );
    final glass = Path()
      ..moveTo(-33, -58)
      ..lineTo(33, -58)
      ..lineTo(25, 61)
      ..quadraticBezierTo(0, 68, -25, 61)
      ..close();
    canvas.drawPath(glass, p..color = Colors.white.withValues(alpha: .55));
    canvas.drawPath(
      Path()
        ..moveTo(-29, -28)
        ..lineTo(29, -28)
        ..lineTo(24, 58)
        ..quadraticBezierTo(0, 63, -24, 58)
        ..close(),
      p
        ..color = [
          const Color(0xffdba346),
          const Color(0xff94ac70),
          const Color(0xffb97477),
        ][index % 3],
    );
    for (final pos in [
      const Offset(-12, -10),
      const Offset(9, 15),
      const Offset(-6, 38),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: pos, width: 19, height: 17),
          const Radius.circular(4),
        ),
        p..color = Colors.white.withValues(alpha: .3),
      );
    }
    canvas.drawLine(
      const Offset(14, -75),
      const Offset(-3, 42),
      p
        ..color = const Color(0xff5e7761)
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      const Offset(-28, -39),
      20,
      p..color = const Color(0xfff3c968),
    );
    canvas.drawCircle(
      const Offset(-28, -39),
      15,
      p..color = const Color(0xfff9e2a4),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DrinkPainter old) => old.index != index;
}
