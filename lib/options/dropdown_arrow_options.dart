import 'package:cool_dropdown/enums/dropdown_arrow_align.dart';

class DropdownArrowOptions {
  final double width;
  final double height;
  final double borderRadius;
  final DropdownArrowAlign arrowAlign;

  const DropdownArrowOptions({
    required this.width,
    required this.height,
    this.borderRadius = 0,
    this.arrowAlign = DropdownArrowAlign.center,
  });
}
