import 'package:flutter/material.dart';

class DropdownItemOptions {
  final double height;
  final EdgeInsets dropdownItemPadding;

  final Alignment alignment;
  final MainAxisAlignment mainAxisAlignment;

  final BoxDecoration boxDecoration;
  final BoxDecoration selectedBoxDecoration;
  final TextStyle textStyle;
  final TextStyle selectedTextStyle;

  DropdownItemOptions({
    required this.height,
    required this.dropdownItemPadding,
    required this.alignment,
    required this.mainAxisAlignment,
    required this.boxDecoration,
    required this.selectedBoxDecoration,
    required this.textStyle,
    required this.selectedTextStyle,
  });
}
