import 'package:flutter/material.dart';

class DropdownOptions {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  final DropdownGap gap;

  final EdgeInsets padding;

  DropdownOptions({
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.gap = DropdownGap.zero,
    this.padding = EdgeInsets.zero,
  });
}

class DropdownGap {
  final double top;
  final double bottom;
  final double gapBetweenItems;

  const DropdownGap.all(double gap)
      : this(
          top: gap,
          bottom: gap,
          gapBetweenItems: gap,
        );

  const DropdownGap.only({
    this.top = 0,
    this.bottom = 0,
    this.gapBetweenItems = 0,
  });

  static const DropdownGap zero = DropdownGap.all(0);

  const DropdownGap({
    this.top = 0,
    this.bottom = 0,
    this.gapBetweenItems = 0,
  });
}
