import 'dart:math';

import 'package:cool_dropdown/enums/triangle_align.dart';
import 'package:flutter/material.dart';

class DropdownBodyShapeBorder extends ShapeBorder {
  final _Arrow arrow;
  final double radius;
  final bool isArrowDown;
  final DropdownArrowAlign triangleAlign;

  DropdownBodyShapeBorder({
    this.arrow = const _Arrow(
      width: 30.0,
      height: 20.0,
      borderRadius: 5.0,
    ),
    this.radius = 16.0,
    this.isArrowDown = false,
    this.triangleAlign = DropdownArrowAlign.right,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(
      top: isArrowDown ? arrow.height : 0,
      bottom: isArrowDown ? 0 : arrow.height);

  @override
  ShapeBorder scale(double t) => this;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(
        path, BorderSide(color: Colors.black, width: 2.0).toPaint());
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight);
    return isArrowDown
        ? roundedDropdownBodyArrowDownPath(rect)
        : roundedDropdownBodyArrowUpPath(rect);
  }

  Path roundedDropdownBodyPath(Rect rect) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight);
    final boxWidth = rect.width;
    final boxHeight = rect.height;
    final boxOffset = Offset(rect.topLeft.dx, rect.topLeft.dy);

    final path = Path()
      ..moveTo(boxOffset.dx, radius + boxOffset.dy)
      ..arcToPoint(Offset(radius + boxOffset.dx, boxOffset.dy),
          radius: Radius.circular(radius))
      ..lineTo(boxWidth - radius + boxOffset.dx, boxOffset.dy)
      ..arcToPoint(Offset(boxWidth + boxOffset.dx, radius + boxOffset.dy),
          radius: Radius.circular(radius))
      ..lineTo(boxWidth + boxOffset.dx, boxHeight - radius + boxOffset.dy)
      ..arcToPoint(
          Offset(boxWidth - radius + boxOffset.dx, boxHeight + boxOffset.dy),
          radius: Radius.circular(radius))
      ..lineTo(radius + boxOffset.dx, boxHeight + boxOffset.dy)
      ..arcToPoint(Offset(boxOffset.dx, boxHeight - radius + boxOffset.dy),
          radius: Radius.circular(radius))
      ..lineTo(boxOffset.dx, radius + boxOffset.dy);
    return path;
  }

  Path roundedDropdownBodyArrowDownPath(Rect rect) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight);
    final boxWidth = rect.width;
    final boxHeight = rect.height;
    final boxOffset = Offset(rect.topLeft.dx, rect.topLeft.dy - arrow.height);

    final arrowPosition = _calcArrowPosition(boxWidth);

    final bottomCenterOffset = Offset(arrowPosition.center + boxOffset.dx,
        arrow.borderRadius + boxHeight + arrow.height + boxOffset.dy);
    final bottomCenterTheta = atan(arrow.height / (arrow.width / 2));

    final path = Path()
      ..moveTo(boxOffset.dx, radius + boxOffset.dy)
      ..arcToPoint(Offset(radius + boxOffset.dx, boxOffset.dy),
          radius: Radius.circular(radius))
      ..lineTo(boxWidth - radius + boxOffset.dx, boxOffset.dy)
      ..arcToPoint(Offset(boxWidth + boxOffset.dx, radius + boxOffset.dy),
          radius: Radius.circular(radius))
      ..lineTo(boxWidth + boxOffset.dx, boxHeight - radius + boxOffset.dy)
      ..arcToPoint(
          Offset(boxWidth - radius + boxOffset.dx, boxHeight + boxOffset.dy),
          radius: Radius.circular(radius))
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
      ..lineTo(radius + boxOffset.dx, boxHeight + boxOffset.dy)
      ..arcToPoint(Offset(boxOffset.dx, boxHeight - radius + boxOffset.dy),
          radius: Radius.circular(radius))
      ..lineTo(boxOffset.dx, radius + boxOffset.dy);
    return path;
  }

  Path roundedDropdownBodyArrowUpPath(Rect rect) {
    final boxWidth = rect.width;
    final boxHeight = rect.height;
    final boxOffset = Offset(rect.topLeft.dx, rect.topLeft.dy + arrow.height);

    final arrowPosition = _calcArrowPosition(boxWidth);

    final topCenterOffset = Offset(
        arrowPosition.center + boxOffset.dx, arrow.borderRadius + boxOffset.dy);
    final topCenterTheta = atan(arrow.height / (arrow.width / 2));

    final path = Path()
      ..moveTo(boxOffset.dx, radius + arrow.height + boxOffset.dy)
      ..arcToPoint(Offset(radius + boxOffset.dx, arrow.height + boxOffset.dy),
          radius: Radius.circular(radius))
      // arrow start
      ..lineTo(arrowPosition.left + boxOffset.dx, arrow.height + boxOffset.dy)
      ..arcTo(
          Rect.fromCircle(center: topCenterOffset, radius: arrow.borderRadius),
          pi * (3 / 2) - topCenterTheta,
          topCenterTheta * 2,
          false)
      ..lineTo(arrowPosition.right + boxOffset.dx, arrow.height + boxOffset.dy)
      // arrow end
      ..lineTo(boxWidth - radius + boxOffset.dx, arrow.height + boxOffset.dy)
      ..arcToPoint(
          Offset(boxWidth + boxOffset.dx, radius + arrow.height + boxOffset.dy),
          radius: Radius.circular(radius))
      ..lineTo(boxWidth + boxOffset.dx,
          boxHeight - radius + arrow.height + boxOffset.dy)
      ..arcToPoint(
          Offset(boxWidth - radius + boxOffset.dx,
              boxHeight + arrow.height + boxOffset.dy),
          radius: Radius.circular(radius))
      ..lineTo(radius + boxOffset.dx, boxHeight + arrow.height + boxOffset.dy)
      ..arcToPoint(
          Offset(
              boxOffset.dx, boxHeight - radius + arrow.height + boxOffset.dy),
          radius: Radius.circular(radius))
      ..lineTo(boxOffset.dx, radius + arrow.height + boxOffset.dy);
    return path;
  }

  _ArrowPosition _calcArrowPosition(double boxWidth) {
    final boxRadius = radius;

    switch (triangleAlign) {
      case DropdownArrowAlign.left:
        return _ArrowPosition(
          left: boxRadius,
          center: boxRadius + arrow.width / 2,
          right: boxRadius + arrow.width,
        );
      case DropdownArrowAlign.center:
        return _ArrowPosition(
          left: boxWidth / 2 - arrow.width / 2,
          center: boxWidth / 2,
          right: boxWidth / 2 + arrow.width / 2,
        );
      case DropdownArrowAlign.right:
        return _ArrowPosition(
          left: boxWidth - boxRadius - arrow.width,
          center: boxWidth - boxRadius - arrow.width / 2,
          right: boxWidth - boxRadius,
        );
    }
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();
}

class _Arrow {
  final double width;
  final double height;
  final double borderRadius;

  const _Arrow({
    required this.width,
    required this.height,
    required this.borderRadius,
  });
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
