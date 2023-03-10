import 'package:flutter/material.dart';

class CoolDropdownItem<T> {
  final String label;
  final Widget? icon;
  final Widget? selectedIcon;
  final T value;

  CoolDropdownItem({
    required this.label,
    this.icon,
    this.selectedIcon,
    required this.value,
  });
}
