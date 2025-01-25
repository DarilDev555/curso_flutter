import 'package:flutter/material.dart';

class HeaderLogin extends StatelessWidget {
  const HeaderLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 300,
      width: double.infinity,
      // color: Colors.red,
      child: CustomPaint(
        painter: _HeaderLogin(colors: colors),
      ),
    );
  }
}

class _HeaderLogin extends CustomPainter {
  final ColorScheme colors;

  _HeaderLogin({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect =
        Rect.fromCircle(center: const Offset(150.0, 50.0), radius: 180);

    Gradient gradient = LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          colors.primary,
          colors.inversePrimary,
        ]);

    final paint = Paint()..shader = gradient.createShader(rect);

    paint.style = PaintingStyle.fill;
    // paint.strokeWidth = 5;

    final path = Path();
    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * .45, size.height, size.width, size.height * 0.73);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
