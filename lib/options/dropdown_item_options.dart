import 'package:flutter/material.dart';

class DropdownItemOptions {
  final double height;
  final EdgeInsets padding;

  final Alignment alignment;
  final MainAxisAlignment mainAxisAlignment;

  final BoxDecoration boxDecoration;
  final BoxDecoration selectedBoxDecoration;
  final TextStyle textStyle;
  final TextStyle selectedTextStyle;
  final EdgeInsets selectedPadding;

  final bool isReverse;

  const DropdownItemOptions({
    this.height = 40,
    this.padding = const EdgeInsets.only(left: 10, right: 10),
    this.alignment = Alignment.centerLeft,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.boxDecoration = const BoxDecoration(
      color: Color(0xFFFFFFFF),
    ),
    this.selectedBoxDecoration = const BoxDecoration(
      color: Color(0XFFEFFAF0),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    this.textStyle = const TextStyle(
      color: Color(0xff000000),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    this.selectedTextStyle = const TextStyle(
      color: Color(0xFF6FCC76),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    this.selectedPadding = const EdgeInsets.only(left: 20, right: 10),
    this.isReverse = false,
  });
}
