import 'package:cool_dropdown/enums/dropdown_item_render.dart';
import 'package:flutter/material.dart';

class DropdownItemOptions {
  final double height;

  final EdgeInsets padding, selectedPadding;
  final Alignment alignment;
  final MainAxisAlignment mainAxisAlignment;
  final DropdownItemRender render;

  final BoxDecoration boxDecoration, selectedBoxDecoration;
  final TextStyle textStyle, selectedTextStyle;
  final TextOverflow textOverflow;

  final bool isMarquee;

  final Duration duration, marqueeDuration, backDuration, pauseDuration;

  const DropdownItemOptions({
    this.height = 40,
    this.padding = const EdgeInsets.only(left: 10, right: 10),
    this.alignment = Alignment.centerLeft,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.render = DropdownItemRender.all,
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
    this.textOverflow = TextOverflow.ellipsis,
    this.isMarquee = false,
    this.duration = const Duration(milliseconds: 300),
    this.marqueeDuration = const Duration(milliseconds: 6000),
    this.backDuration = const Duration(milliseconds: 800),
    this.pauseDuration = const Duration(milliseconds: 800),
  });
}
