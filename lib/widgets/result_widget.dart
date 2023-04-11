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

  final Function onChange;
  final Function? onOpen;

  final CoolDropdownItem<T>? defaultValue;

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
    this.defaultValue,
    this.onOpen,
    this.isResultIconLabel = true,
    this.isResultLabel = true,
    this.isDropdownLabel = true,
    this.resultIconRotation = true,
    this.labelIconGap = 10,
    this.resultIconLeftGap = 10,
  }) : super(key: key);

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState<T> extends State<ResultWidget> {
  final resultKey = GlobalKey();
  CoolDropdownItem<T>? selectedItem;
  late bool isOpen = false;

  void open() {
    isOpen = true;
    if (widget.onOpen != null) {
      widget.onOpen!(isOpen);
    }
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
          closeDropdown: () => widget.controller.close(),
          getSelectedItem: (selectedItem) async {
            // sizeController = AnimationController(
            //   vsync: this,
            //   duration: au.isAnimation(
            //       status: widget.isAnimation,
            //       duration: Duration(milliseconds: 150)),
            // );
            // textWidth = CurvedAnimation(
            //   parent: sizeController,
            //   curve: Curves.fastOutSlowIn,
            // );
            // setState(() {
            //   this.selectedItem = selectedItem;
            // });
            // await sizeController.forward();
          },
          selectedItem: selectedItem,
          bodyContext: context,
          isDropdownLabel: widget.isDropdownLabel,
        ));
  }

  @override
  void initState() {
    // placeholder 셋팅
    setDefaultValue();
    super.initState();
  }

  void setDefaultValue() {}

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
    return WillPopScope(
      onWillPop: () async {
        if (isOpen) {
          widget.controller.close();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: GestureDetector(
        onTap: () => open(),
        child: Container(
          key: resultKey,
          width: widget.resultOptions.width,
          height: widget.resultOptions.height,
          padding: widget.resultOptions.padding,
          decoration: widget.resultOptions.boxDecoration,
          child: Align(
            alignment: widget.resultOptions.alignment,
            child: widget.isResultIconLabel
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment:
                              widget.resultOptions.mainAxisAlignment,
                          children: [
                            if (widget.isResultLabel)
                              Flexible(
                                child: Container(
                                  child: Text(
                                    selectedItem?.label ??
                                        widget.resultOptions.placeholder ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    style: selectedItem != null
                                        ? widget.resultOptions.textStyle
                                        : widget
                                            .resultOptions.placeholderTextStyle,
                                  ),
                                ),
                              ),
                            if (widget.isResultLabel)
                              SizedBox(
                                width: widget.labelIconGap,
                              ),
                            selectedItem?.icon ?? SizedBox(),
                          ].isReverse(widget.dropdownItemOptions.isReverse),
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
        ),
      ),
    );
  }
}
