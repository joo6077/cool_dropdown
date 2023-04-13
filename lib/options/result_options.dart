import 'package:cool_dropdown/enums/dropdown_render.dart';
import 'package:flutter/material.dart';

class ResultOptions {
  final double width;
  final double height;
  final double space;

  final Alignment alignment;
  final EdgeInsets padding;
  final MainAxisAlignment mainAxisAlignment;
  final ResultRender render;

  final BoxDecoration boxDecoration;
  final BoxDecoration openBoxDecoration;
  final BoxDecoration errorBoxDecoration;
  final TextStyle textStyle;
  final TextStyle placeholderTextStyle;

  final Widget? icon;

  final String? placeholder;

  final bool isReverse;

  const ResultOptions({
    this.width = 220,
    this.height = 50,
    this.space = 10,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.render = ResultRender.all,
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
    this.openBoxDecoration = const BoxDecoration(
      color: Color(0xFFFFFFFF),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border(
        top: BorderSide(width: 1, color: Color(0xFF6FCC76)),
        bottom: BorderSide(width: 1, color: Color(0xFF6FCC76)),
        left: BorderSide(width: 1, color: Color(0xFF6FCC76)),
        right: BorderSide(width: 1, color: Color(0xFF6FCC76)),
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0x1a9E9E9E),
          spreadRadius: 1,
          blurRadius: 10,
          offset: Offset(0, 1),
        ),
      ],
    ),
    this.errorBoxDecoration = const BoxDecoration(
      color: Color(0xFFFFFFFF),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border(
        top: BorderSide(width: 1, color: Color(0xFFE74C3C)),
        bottom: BorderSide(width: 1, color: Color(0xFFE74C3C)),
        left: BorderSide(width: 1, color: Color(0xFFE74C3C)),
        right: BorderSide(width: 1, color: Color(0xFFE74C3C)),
      ),
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
