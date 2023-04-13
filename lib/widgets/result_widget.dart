import 'dart:math';

import 'package:cool_dropdown/widgets/dropdown_widget.dart';

import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_arrow_options.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:cool_dropdown/options/result_options.dart';
import 'package:cool_dropdown/utils/extension_util.dart';
import 'package:flutter/material.dart';

class ResultWidget<T> extends StatefulWidget {
  final List<CoolDropdownItem<T>> dropdownList;

  final ResultOptions resultOptions;
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownArrowOptions dropdownArrowOptions;
  final DropdownController controller;

  final Function(T t) onChange;

  final CoolDropdownItem<T>? defaultItem;

  final bool isResultIconLabel;
  final bool isResultLabel;
  final bool isDropdownLabel; // late
  final bool resultIconRotation;

  // style
  final double labelIconGap;
  final double resultIconLeftGap;

  const ResultWidget({
    Key? key,
    required this.dropdownList,
    required this.resultOptions,
    required this.dropdownOptions,
    required this.dropdownItemOptions,
    required this.dropdownArrowOptions,
    required this.controller,
    required this.onChange,
    this.defaultItem,
    this.isResultIconLabel = true,
    this.isResultLabel = true,
    this.isDropdownLabel = true,
    this.resultIconRotation = true,
    this.labelIconGap = 10,
    this.resultIconLeftGap = 10,
  }) : super(key: key);

  @override
  State<ResultWidget<T>> createState() => _ResultWidgetState<T>();
}

class _ResultWidgetState<T> extends State<ResultWidget<T>> {
  final resultKey = GlobalKey();
  CoolDropdownItem<T>? selectedItem;

  late final _decorationBoxTween = DecorationTween(
    begin: widget.resultOptions.boxDecoration,
    end: widget.resultOptions.openBoxDecoration,
  ).animate(widget.controller.resultBox);

  @override
  void initState() {
    if (widget.defaultItem == null) return;
    _setSelectedItem(widget.defaultItem!);
    super.initState();
  }

  void open() {
    widget.controller.open(
        context: context,
        child: DropdownWidget<T>(
          controller: widget.controller,
          dropdownOptions: widget.dropdownOptions,
          dropdownItemOptions: widget.dropdownItemOptions,
          dropdownArrowOptions: widget.dropdownArrowOptions,
          resultKey: resultKey,
          onChange: widget.onChange,
          dropdownList: widget.dropdownList,
          labelIconGap: widget.labelIconGap,
          isResultLabel: widget.isResultLabel,
          getSelectedItem: (index) =>
              _setSelectedItem(widget.dropdownList[index]),
          selectedItem: selectedItem,
          bodyContext: context,
          isDropdownLabel: widget.isDropdownLabel,
        ));
  }

  void _setSelectedItem(CoolDropdownItem<T> item) {
    setState(() {
      selectedItem = item;
    });
  }

  Widget buildResultIcon() {
    return AnimatedBuilder(
        animation: widget.controller.controller,
        builder: (_, __) {
          return widget.resultOptions.icon == null
              ? const SizedBox()
              : Transform.rotate(
                  angle: pi * widget.controller.rotation.value,
                  child: widget.resultOptions.icon,
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => open(),
      child: AnimatedBuilder(
          animation: widget.controller.controller,
          builder: (_, __) {
            return Container(
              key: resultKey,
              width: widget.resultOptions.width,
              height: widget.resultOptions.height,
              padding: widget.resultOptions.padding,
              decoration: _decorationBoxTween.value,
              child: Align(
                alignment: widget.resultOptions.alignment,
                child: widget.isResultIconLabel
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return SizeTransition(
                                  sizeFactor: animation,
                                  axisAlignment: -2,
                                  child: child,
                                );
                              },
                              child: Row(
                                key: ValueKey(selectedItem?.label),
                                mainAxisAlignment:
                                    widget.resultOptions.mainAxisAlignment,
                                children: [
                                  if (widget.isResultLabel)
                                    Flexible(
                                      child: Container(
                                        child: Text(
                                          selectedItem?.label ??
                                              widget
                                                  .resultOptions.placeholder ??
                                              '',
                                          overflow: TextOverflow.ellipsis,
                                          style: selectedItem != null
                                              ? widget.resultOptions.textStyle
                                              : widget.resultOptions
                                                  .placeholderTextStyle,
                                        ),
                                      ),
                                    ),
                                  if (widget.isResultLabel)
                                    SizedBox(
                                      width: widget.labelIconGap,
                                    ),
                                  selectedItem?.icon ?? SizedBox(),
                                ].isReverse(
                                    widget.dropdownItemOptions.isReverse),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.resultIconLeftGap,
                          ),
                          buildResultIcon(),
                        ].isReverse(widget.resultOptions.isReverse),
                      )
                    : buildResultIcon(),
              ),
            );
          }),
    );
  }
}
