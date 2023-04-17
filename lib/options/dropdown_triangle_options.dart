import 'package:cool_dropdown/enums/dropdown_triangle_align.dart';

class DropdownTriangleOptions {
  final double width, height, left, borderRadius;
  final DropdownTriangleAlign align;

  const DropdownTriangleOptions({
    this.width = 10,
    this.height = 10,
    this.left = 0,
    this.borderRadius = 0,
    this.align = DropdownTriangleAlign.center,
  });
}
