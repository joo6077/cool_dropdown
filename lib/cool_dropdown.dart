library cool_dropdown;

import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_arrow_options.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:cool_dropdown/options/result_options.dart';
import 'package:cool_dropdown/widgets/result_widget.dart';
import 'package:flutter/material.dart';

export 'package:cool_dropdown/controllers/dropdown_controller.dart';
export 'package:cool_dropdown/enums/dropdown_align.dart';
export 'package:cool_dropdown/enums/dropdown_arrow_align.dart';
export 'package:cool_dropdown/options/dropdown_arrow_options.dart';
export 'package:cool_dropdown/options/dropdown_item_options.dart';
export 'package:cool_dropdown/options/dropdown_options.dart';
export 'package:cool_dropdown/options/result_options.dart';
export 'package:cool_dropdown/customPaints/arrow_down_painter.dart';

class CoolDropdown<T> extends StatelessWidget {
  final List<CoolDropdownItem<T>> dropdownList;
  final CoolDropdownItem<T>? defaultItem;

  final ResultOptions resultOptions;
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownArrowOptions dropdownArrowOptions;
  final DropdownController controller;

  final Function(T t) onChange;

  CoolDropdown({
    Key? key,
    required this.dropdownList,
    this.defaultItem,
    this.resultOptions = const ResultOptions(),
    this.dropdownOptions = const DropdownOptions(),
    this.dropdownItemOptions = const DropdownItemOptions(),
    this.dropdownArrowOptions = const DropdownArrowOptions(),
    required this.controller,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResultWidget<T>(
      dropdownList: dropdownList,
      resultOptions: resultOptions,
      dropdownOptions: dropdownOptions,
      dropdownItemOptions: dropdownItemOptions,
      dropdownArrowOptions: dropdownArrowOptions,
      controller: controller,
      onChange: onChange,
      defaultItem: defaultItem,
    );
  }
}
