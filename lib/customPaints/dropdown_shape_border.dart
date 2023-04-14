import 'dart:math';

import 'package:cool_dropdown/enums/dropdown_triangle_align.dart';
import 'package:cool_dropdown/options/dropdown_triangle_options.dart';
import 'package:flutter/material.dart';

class DropdownShapeBorder extends ShapeBorder {
  final DropdownTriangleOptions arrow;
  final BorderRadius radius;
  final bool isArrowDown;
  final DropdownTriangleAlign arrowAlign;
  final BorderSide borderSide;

  DropdownShapeBorder({
    this.arrow = const DropdownTriangleOptions(
      width: 30.0,
      height: 20.0,
      borderRadius: .0,
    ),
    this.radius = const BorderRadius.all(Radius.circular(0)),
    required this.isArrowDown,
    required this.arrowAlign,
    this.borderSide = BorderSide.none,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(
        top: isArrowDown ? 0 : arrow.height,
        bottom: isArrowDown ? arrow.height : 0,
      );

  @override
  ShapeBorder scale(double t) => this;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, borderSide.toPaint());
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(
        rect.topLeft, rect.bottomRight - Offset(0, arrow.height));
    return isArrowDown
        ? roundedDropdownArrowDownPath(rect)
        : roundedDropdownArrowUpPath(rect);
  }

  Path roundedDropdownBodyPath(Rect rect) {
    final boxWidth = rect.width;
    final boxHeight = rect.height;
    final boxOffset = Offset(rect.topLeft.dx, rect.topLeft.dy);

    final path = Path()
      ..moveTo(boxOffset.dx, radius.topLeft.y + boxOffset.dy)
      ..arcToPoint(Offset(radius.topLeft.x + boxOffset.dx, boxOffset.dy),
          radius: radius.topLeft)
      ..lineTo(boxWidth - radius.topRight.x + boxOffset.dx, boxOffset.dy)
      ..arcToPoint(
          Offset(boxWidth + boxOffset.dx, radius.topRight.y + boxOffset.dy),
          radius: radius.topRight)
      ..lineTo(boxWidth + boxOffset.dx,
          boxHeight - radius.bottomRight.y + boxOffset.dy)
      ..arcToPoint(
          Offset(boxWidth - radius.bottomRight.x + boxOffset.dx,
              boxHeight + boxOffset.dy),
          radius: radius.bottomRight)
      ..lineTo(radius.bottomLeft.x + boxOffset.dx, boxHeight + boxOffset.dy)
      ..arcToPoint(
          Offset(boxOffset.dx, boxHeight - radius.bottomLeft.y + boxOffset.dy),
          radius: radius.bottomLeft)
      ..lineTo(boxOffset.dx, radius.bottomLeft.y + boxOffset.dy);
    return path;
  }

  Path roundedDropdownArrowDownPath(Rect rect) {
    final boxWidth = rect.width;
    final boxHeight = rect.height;
    final boxOffset = Offset(rect.topLeft.dx, rect.topLeft.dy);

    final arrowPosition = _calcArrowPosition(boxWidth);

    final bottomCenterOffset = Offset(arrowPosition.center + boxOffset.dx,
        arrow.borderRadius + boxHeight + arrow.height + boxOffset.dy);
    final bottomCenterTheta = atan(arrow.height / (arrow.width / 2));

    final path = Path()
      ..moveTo(boxOffset.dx, radius.topLeft.y + boxOffset.dy)
      ..arcToPoint(Offset(radius.topLeft.x + boxOffset.dx, boxOffset.dy),
          radius: radius.topLeft)
      ..lineTo(boxWidth - radius.topRight.x + boxOffset.dx, boxOffset.dy)
      ..arcToPoint(
          Offset(boxWidth + boxOffset.dx, radius.topRight.y + boxOffset.dy),
          radius: radius.topRight)
      ..lineTo(boxWidth + boxOffset.dx,
          boxHeight - radius.bottomRight.y + boxOffset.dy)
      ..arcToPoint(
          Offset(boxWidth - radius.bottomRight.x + boxOffset.dx,
              boxHeight + boxOffset.dy),
          radius: radius.bottomRight)
      // arrow start
      ..lineTo(arrowPosition.right + boxOffset.dx, boxHeight + boxOffset.dy)
      ..arcTo(
          Rect.fromCircle(
              center: bottomCenterOffset, radius: arrow.borderRadius),
          pi * (1 / 2) - bottomCenterTheta,
          bottomCenterTheta * 2,
          false)
      ..lineTo(arrowPosition.left + boxOffset.dx, boxHeight + boxOffset.dy)
      // arrow end
      ..lineTo(radius.bottomLeft.x + boxOffset.dx, boxHeight + boxOffset.dy)
      ..arcToPoint(
          Offset(boxOffset.dx, boxHeight - radius.bottomLeft.y + boxOffset.dy),
          radius: radius.bottomLeft)
      ..lineTo(boxOffset.dx, radius.bottomLeft.y + boxOffset.dy);
    return path;
  }

  Path roundedDropdownArrowUpPath(Rect rect) {
    final boxWidth = rect.width;
    final boxHeight = rect.height;
    final boxOffset = Offset(rect.topLeft.dx, rect.topLeft.dy);

    final arrowPosition = _calcArrowPosition(boxWidth);

    final topCenterOffset = Offset(
        arrowPosition.center + boxOffset.dx, arrow.borderRadius + boxOffset.dy);
    final topCenterTheta = atan(arrow.height / (arrow.width / 2));

    final path = Path()
      ..moveTo(boxOffset.dx, radius.topLeft.y + arrow.height + boxOffset.dy)
      ..arcToPoint(
          Offset(radius.topLeft.x + boxOffset.dx, arrow.height + boxOffset.dy),
          radius: radius.topLeft)
      // arrow start
      ..lineTo(arrowPosition.left + boxOffset.dx, arrow.height + boxOffset.dy)
      ..arcTo(
          Rect.fromCircle(center: topCenterOffset, radius: arrow.borderRadius),
          pi * (3 / 2) - topCenterTheta,
          topCenterTheta * 2,
          false)
      ..lineTo(arrowPosition.right + boxOffset.dx, arrow.height + boxOffset.dy)
      // arrow end
      ..lineTo(boxWidth - radius.topRight.x + boxOffset.dx,
          arrow.height + boxOffset.dy)
      ..arcToPoint(
          Offset(boxWidth + boxOffset.dx,
              radius.topRight.y + arrow.height + boxOffset.dy),
          radius: radius.topRight)
      ..lineTo(boxWidth + boxOffset.dx,
          boxHeight - radius.bottomRight.y + arrow.height + boxOffset.dy)
      ..arcToPoint(
          Offset(boxWidth - radius.bottomRight.x + boxOffset.dx,
              boxHeight + arrow.height + boxOffset.dy),
          radius: radius.bottomRight)
      ..lineTo(radius.bottomLeft.x + boxOffset.dx,
          boxHeight + arrow.height + boxOffset.dy)
      ..arcToPoint(
          Offset(boxOffset.dx,
              boxHeight - radius.bottomLeft.y + arrow.height + boxOffset.dy),
          radius: radius.bottomLeft)
      ..lineTo(boxOffset.dx, radius.bottomLeft.x + arrow.height + boxOffset.dy);
    return path;
  }

  _ArrowPosition _calcArrowPosition(double boxWidth) {
    final boxRadius = radius;

    switch (arrowAlign) {
      case DropdownTriangleAlign.left:
        return _ArrowPosition(
          left: boxRadius.topLeft.x,
          center: boxRadius.topLeft.x + arrow.width / 2,
          right: boxRadius.topLeft.x + arrow.width,
        );
      case DropdownTriangleAlign.center:
        return _ArrowPosition(
          left: boxWidth / 2 - arrow.width / 2,
          center: boxWidth / 2,
          right: boxWidth / 2 + arrow.width / 2,
        );
      case DropdownTriangleAlign.right:
        return _ArrowPosition(
          left: boxWidth - boxRadius.topRight.x - arrow.width,
          center: boxWidth - boxRadius.topRight.x - arrow.width / 2,
          right: boxWidth - boxRadius.topRight.x,
        );
    }
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();
}

class _ArrowPosition {
  final double left;
  final double center;
  final double right;

  _ArrowPosition({
    required this.left,
    required this.center,
    required this.right,
  });
}
