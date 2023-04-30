import 'dart:math';

import 'package:cool_dropdown/enums/dropdown_triangle_align.dart';
import 'package:cool_dropdown/options/dropdown_triangle_options.dart';
import 'package:flutter/material.dart';

class DropdownShapeBorder extends ShapeBorder {
  final DropdownTriangleOptions triangle;
  final BorderRadius radius;
  final bool isTriangleDown;
  final DropdownTriangleAlign arrowAlign;
  final BorderSide borderSide;

  DropdownShapeBorder({
    this.triangle = const DropdownTriangleOptions(
      width: 30.0,
      height: 20.0,
      borderRadius: .0,
    ),
    this.radius = const BorderRadius.all(Radius.circular(0)),
    required this.isTriangleDown,
    required this.arrowAlign,
    this.borderSide = BorderSide.none,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(
        top: isTriangleDown ? 0 : triangle.height,
        bottom: isTriangleDown ? triangle.height : 0,
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
        rect.topLeft, rect.bottomRight - Offset(0, triangle.height));
    return roundedDropdownPath(rect);
  }

  Path roundedDropdownPath(Rect rect) {
    final calcTriangleHeight = isTriangleDown ? 0 : triangle.height;

    rect = Rect.fromLTWH(rect.topLeft.dx, rect.topLeft.dy + calcTriangleHeight,
        rect.width, rect.height);

    final path = Path();
    _drawTopLeftCorner(path, rect);

    if (triangle.width > 0 && triangle.height > 0) {
      if (!isTriangleDown) {
        _drawTriangleUp(
            path: path,
            boxRect: rect.shift(Offset(0, -triangle.height)),
            trianglePosition: _calcArrowPosition(rect.width),
            triangle: triangle);
      }
    }
    _drawTopRightCorner(path, rect);
    _drawBottomRightCorner(path, rect);

    if (triangle.width > 0 && triangle.height > 0) {
      if (isTriangleDown) {
        _drawTriangleDown(
            path: path,
            boxRect: rect,
            trianglePosition: _calcArrowPosition(rect.width),
            triangle: triangle);
      }
    }

    _drawBottomLeftCorner(path, rect);
    return path;
  }

  void _drawTopLeftCorner(Path path, Rect rect) {
    path
      ..moveTo(rect.left, radius.topLeft.y + rect.top)
      ..arcToPoint(Offset(radius.topLeft.x + rect.left, rect.top),
          radius: radius.topLeft);
  }

  void _drawTopRightCorner(Path path, Rect rect) {
    path
      ..lineTo(rect.width - radius.topRight.x + rect.left, rect.top)
      ..arcToPoint(Offset(rect.width + rect.left, radius.topRight.y + rect.top),
          radius: radius.topRight);
  }

  void _drawBottomRightCorner(Path path, Rect rect) {
    path
      ..lineTo(
          rect.width + rect.left, rect.height - radius.bottomRight.y + rect.top)
      ..arcToPoint(
          Offset(rect.width - radius.bottomRight.x + rect.left,
              rect.height + rect.top),
          radius: radius.bottomRight);
  }

  void _drawBottomLeftCorner(Path path, Rect rect) {
    path
      ..lineTo(radius.bottomLeft.x + rect.left, rect.height + rect.top)
      ..arcToPoint(
          Offset(rect.left, rect.height - radius.bottomLeft.y + rect.top),
          radius: radius.bottomLeft)
      ..lineTo(rect.left, radius.bottomLeft.y + rect.top);
  }

  void _drawTriangleDown({
    required Path path,
    required Rect boxRect,
    required _TrianglePosition trianglePosition,
    required DropdownTriangleOptions triangle,
  }) {
    final bottomCenterOffset = Offset(
        trianglePosition.center + boxRect.left + triangle.left,
        -triangle.borderRadius +
            boxRect.height +
            triangle.height +
            boxRect.top);
    final bottomCenterTheta = atan(triangle.height / (triangle.width / 2));

    path
      ..lineTo(trianglePosition.right + boxRect.left + triangle.left,
          boxRect.height + boxRect.top)
      ..arcTo(
          Rect.fromCircle(
              center: bottomCenterOffset, radius: triangle.borderRadius),
          pi * (1 / 2) - bottomCenterTheta,
          bottomCenterTheta * 2,
          false)
      ..lineTo(trianglePosition.left + boxRect.left + triangle.left,
          boxRect.height + boxRect.top);
  }

  void _drawTriangleUp({
    required Path path,
    required Rect boxRect,
    required _TrianglePosition trianglePosition,
    required DropdownTriangleOptions triangle,
  }) {
    final topCenterOffset = Offset(
        trianglePosition.center + boxRect.left + triangle.left,
        triangle.borderRadius + boxRect.top);
    final topCenterTheta = atan(triangle.height / (triangle.width / 2));

    path
      ..lineTo(trianglePosition.left + boxRect.left + triangle.left,
          triangle.height + boxRect.top)
      ..arcTo(
          Rect.fromCircle(
              center: topCenterOffset, radius: triangle.borderRadius),
          pi * (3 / 2) - topCenterTheta,
          topCenterTheta * 2,
          false)
      ..lineTo(trianglePosition.right + boxRect.left + triangle.left,
          triangle.height + boxRect.top);
  }

  _TrianglePosition _calcArrowPosition(double boxWidth) {
    final boxRadius = radius;

    switch (arrowAlign) {
      case DropdownTriangleAlign.left:
        return _TrianglePosition(
          left: boxRadius.topLeft.x,
          center: boxRadius.topLeft.x + triangle.width / 2,
          right: boxRadius.topLeft.x + triangle.width,
        );
      case DropdownTriangleAlign.center:
        return _TrianglePosition(
          left: boxWidth / 2 - triangle.width / 2,
          center: boxWidth / 2,
          right: boxWidth / 2 + triangle.width / 2,
        );
      case DropdownTriangleAlign.right:
        return _TrianglePosition(
          left: boxWidth - boxRadius.topRight.x - triangle.width,
          center: boxWidth - boxRadius.topRight.x - triangle.width / 2,
          right: boxWidth - boxRadius.topRight.x,
        );
    }
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();
}

class _TrianglePosition {
  final double left;
  final double center;
  final double right;

  _TrianglePosition({
    required this.left,
    required this.center,
    required this.right,
  });
}
