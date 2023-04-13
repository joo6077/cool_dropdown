import 'package:cool_dropdown/enums/dropdown_triangle_align.dart';

class DropdownTriangleOptions {
  final double width;
  final double height;
  final double left;

  final double borderRadius;
  final DropdownTriangleAlign arrowAlign;

  const DropdownTriangleOptions({
    this.width = 10,
    this.height = 10,
    this.left = 0,
    this.borderRadius = 0,
    this.arrowAlign = DropdownTriangleAlign.center,
  });
}
