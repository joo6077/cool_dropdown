import 'package:cool_dropdown/customPaints/arrow_down_painter.dart';
import 'package:cool_dropdown/enums/result_render.dart';
import 'package:flutter/material.dart';

class ResultOptions {
  /// Result width
  final double width, height, space;

  /// Result padding
  final EdgeInsets padding;

  /// Result alignment of (text + icon)
  final Alignment alignment;

  /// Result main axis alignment of (text + icon)
  final MainAxisAlignment mainAxisAlignment;

  /// Result render type [label], [icon], [all], [none], [reverse]
  final ResultRender render;

  /// Result box decoration
  final BoxDecoration boxDecoration, openBoxDecoration, errorBoxDecoration;

  /// Result text style
  final TextStyle textStyle, placeholderTextStyle;

  /// Result text is overflow
  final TextOverflow textOverflow;

  /// Result icon
  final Widget? icon;

  /// Result placeholder
  final String? placeholder;

  /// Result is marquee
  final bool isMarquee;

  /// The duration of the switch animation.
  final Duration duration, marqueeDuration, backDuration, pauseDuration;

  const ResultOptions({
    this.width = 220,
    this.height = 50,
    this.space = 10,
    this.alignment = Alignment.center,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
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
    this.icon = const SizedBox(
      width: 10,
      height: 10,
      child: CustomPaint(
        painter: DropdownArrowPainter(),
      ),
    ),
    this.placeholder,
    this.textOverflow = TextOverflow.ellipsis,
    this.isMarquee = false,
    this.duration = const Duration(milliseconds: 300),
    this.marqueeDuration = const Duration(milliseconds: 6000),
    this.backDuration = const Duration(milliseconds: 800),
    this.pauseDuration = const Duration(milliseconds: 800),
  });
}
