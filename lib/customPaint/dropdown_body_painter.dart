import 'package:flutter/material.dart';

class DropdownBodyPainter extends CustomPainter {
  final Size triangleSize;
  final Size dropdownSize;

  DropdownBodyPainter({
    required this.triangleSize,
    required this.dropdownSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, dropdownSize.width, dropdownSize.height),
            Radius.circular(20)),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
