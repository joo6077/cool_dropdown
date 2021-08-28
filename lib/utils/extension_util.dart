import 'package:flutter/material.dart';

extension ReverseList on List<Widget> {
  List<Widget> isReverse(bool isReverse) {
    if (isReverse) {
      return this.reversed.toList();
    } else {
      return this;
    }
  }
}
