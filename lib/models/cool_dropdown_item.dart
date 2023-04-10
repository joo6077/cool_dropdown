import 'package:flutter/material.dart';

class CoolDropdownItem<T> {
  final String label;
  final bool isSelected;
  final Widget? icon;
  final Widget? selectedIcon;
  final T value;

  CoolDropdownItem({
    required this.label,
    this.isSelected = false,
    this.icon,
    this.selectedIcon,
    required this.value,
  });
}
