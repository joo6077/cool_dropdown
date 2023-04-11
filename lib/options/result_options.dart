import 'package:flutter/material.dart';

class ResultOptions {
  final double width;
  final double height;

  final Alignment alignment;
  final EdgeInsets padding;
  final MainAxisAlignment mainAxisAlignment;

  final BoxDecoration boxDecoration;
  final TextStyle textStyle;
  final TextStyle placeholderTextStyle;

  final Widget? icon;

  final String? placeholder;

  final bool isReverse;

  const ResultOptions({
    this.width = 220,
    this.height = 50,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.boxDecoration = const BoxDecoration(
      color: Color(0xFFFFFFFF),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Color(0x1a9E9E9E),
          spreadRadius: 1,
          blurRadius: 10,
          offset: Offset(0, 1),
        ),
      ],
    ),
    this.textStyle = const TextStyle(
      color: Color(0xff000000),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    this.placeholderTextStyle = const TextStyle(
      color: Color(0xff666666),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    this.icon,
    this.placeholder,
    this.isReverse = false,
  });
}
