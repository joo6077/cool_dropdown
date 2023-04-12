import 'package:cool_dropdown/enums/dropdown_arrow_align.dart';

class DropdownArrowOptions {
  final double width;
  final double height;
  final double left;

  final double borderRadius;
  final DropdownArrowAlign arrowAlign;

  const DropdownArrowOptions({
    this.width = 10,
    this.height = 10,
    this.left = 0,
    this.borderRadius = 0,
    this.arrowAlign = DropdownArrowAlign.center,
  });
}
