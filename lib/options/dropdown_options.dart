import 'package:cool_dropdown/enums/dropdown_align.dart';
import 'package:cool_dropdown/enums/dropdown_animation.dart';
import 'package:flutter/material.dart';

class DropdownOptions {
  final double? width;
  final double height;
  final double top;
  final double left;

  final Color color;
  final BorderRadius borderRadius;
  final BorderSide borderSide;
  final List<BoxShadow> shadows;
  final DropdownAnimationType animationType;

  final DropdownAlign align;

  final DropdownGap gap;

  final EdgeInsets padding;

  const DropdownOptions({
    this.width,
    this.height = 220,
    this.top = 0,
    this.left = 0,
    this.color = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.borderSide = BorderSide.none,
    this.shadows = const [],
    this.animationType = DropdownAnimationType.scale,
    this.align = DropdownAlign.center,
    this.gap = DropdownGap.zero,
    this.padding = EdgeInsets.zero,
  });

  double get shadowMaxBlurRadiusPlusMaxSpreadRadius {
    double max = 0;
    for (final shadow in shadows) {
      final blurRadius = shadow.blurRadius;
      final spreadRadius = shadow.spreadRadius;
      final offset = shadow.offset;
      final maxBlurRadiusPlusMaxSpreadRadius =
          blurRadius + spreadRadius + offset.distance;
      if (maxBlurRadiusPlusMaxSpreadRadius > max) {
        max = maxBlurRadiusPlusMaxSpreadRadius;
      }
    }
    return 2 * max;
  }

  /// padding - dropdown border width
  EdgeInsets get calcPadding => EdgeInsets.only(
        top: borderSide.width * 0.5 + padding.top,
        bottom: borderSide.width * 0.5 + padding.bottom,
        left: borderSide.width * 0.5 + padding.left,
        right: borderSide.width * 0.5 + padding.right,
      );

  EdgeInsets get marginGap => EdgeInsets.only(
        top: borderSide.width * 0.5 + shadowMaxBlurRadiusPlusMaxSpreadRadius,
        bottom: borderSide.width * 0.5 + shadowMaxBlurRadiusPlusMaxSpreadRadius,
        left: borderSide.width * 0.5 + shadowMaxBlurRadiusPlusMaxSpreadRadius,
        right: borderSide.width * 0.5 + shadowMaxBlurRadiusPlusMaxSpreadRadius,
      );
}

class DropdownGap {
  final double top;
  final double bottom;
  final double betweenItems;
  final double betweenDropdownAndEdge;

  const DropdownGap.all(double gap)
      : top = gap,
        bottom = gap,
        betweenItems = gap,
        betweenDropdownAndEdge = gap;

  const DropdownGap.only({
    this.top = 0,
    this.bottom = 0,
    this.betweenItems = 0,
    this.betweenDropdownAndEdge = 0,
  });

  static const DropdownGap zero = DropdownGap.all(0);
}
