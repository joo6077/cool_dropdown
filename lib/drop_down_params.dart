import 'package:flutter/material.dart';

class DropDownParams<T> {
  DropDownParams({
    required this.label,
    required this.value,
    this.icon,
    this.selectedIcon,
  });

  final String label;
  final T value;
  final Widget? icon;
  final Widget? selectedIcon;
}
