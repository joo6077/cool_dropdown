import 'package:flutter/material.dart';

class ResultOptions {
  final double width;
  final double height;

  final Alignment resultAlignment;
  final EdgeInsets resultPadding;
  final MainAxisAlignment resultMainAxis;

  final BoxDecoration resultBoxDecoration;
  final TextStyle resultTextStyle;
  final TextStyle placeholderTextStyle;

  ResultOptions({
    required this.width,
    required this.height,
    this.resultAlignment = Alignment.center,
    this.resultPadding = EdgeInsets.zero,
    this.resultMainAxis = MainAxisAlignment.spaceBetween,
    this.resultBoxDecoration = const BoxDecoration(
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
    this.resultTextStyle = const TextStyle(
      color: Color(0xff000000),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    this.placeholderTextStyle = const TextStyle(
      color: Color(0xff666666),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  });
}
