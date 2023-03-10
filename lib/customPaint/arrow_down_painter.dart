import 'package:flutter/material.dart';

class DropdownArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4178592, size.height * 0.7748810);
    path_0.cubicTo(
        size.width * 0.4404533,
        size.height * 0.7974752,
        size.width * 0.4702912,
        size.height * 0.8087602,
        size.width * 0.5001371,
        size.height * 0.8087602);
    path_0.cubicTo(
        size.width * 0.5299831,
        size.height * 0.8087602,
        size.width * 0.5598290,
        size.height * 0.7974752,
        size.width * 0.5824151,
        size.height * 0.7748810);
    path_0.lineTo(size.width * 0.9639590, size.height * 0.3933371);
    path_0.cubicTo(
        size.width * 1.008325,
        size.height * 0.3489715,
        size.width * 1.013173,
        size.height * 0.2755667,
        size.width * 0.9704122,
        size.height * 0.2295878);
    path_0.cubicTo(
        size.width * 0.9252400,
        size.height * 0.1803824,
        size.width * 0.8486085,
        size.height * 0.1787691,
        size.width * 0.8018311,
        size.height * 0.2255546);
    path_0.lineTo(size.width * 0.5566105, size.height * 0.4699685);
    path_0.cubicTo(
        size.width * 0.5251593,
        size.height * 0.5014278,
        size.width * 0.4743325,
        size.height * 0.5014278,
        size.width * 0.4428733,
        size.height * 0.4699685);
    path_0.lineTo(size.width * 0.1984593, size.height * 0.2255546);
    path_0.cubicTo(
        size.width * 0.1516657,
        size.height * 0.1787691,
        size.width * 0.07503428,
        size.height * 0.1795757,
        size.width * 0.02987013,
        size.height * 0.2295878);
    path_0.cubicTo(
        size.width * -0.01288215,
        size.height * 0.2755667,
        size.width * -0.008848915,
        size.height * 0.3489715,
        size.width * 0.03632330,
        size.height * 0.3933371);
    path_0.lineTo(size.width * 0.4178592, size.height * 0.7748810);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.grey.withOpacity(0.7);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
