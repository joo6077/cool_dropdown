import 'dart:developer';
import 'dart:math';

import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/enums/dropdown_render.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_arrow_options.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:cool_dropdown/options/result_options.dart';
import 'package:cool_dropdown/utils/extension_util.dart';
import 'package:cool_dropdown/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';

class ResultWidget<T> extends StatefulWidget {
  final List<CoolDropdownItem<T>> dropdownList;

  final ResultOptions resultOptions;
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownArrowOptions dropdownArrowOptions;
  final DropdownController controller;

  final Function(T t) onChange;
  final Function(bool)? onOpen;

  final CoolDropdownItem<T>? defaultItem;

  final bool isResultIconLabel;
  final bool isResultLabel;
  final bool isDropdownLabel;
  final bool resultIconRotation;

  const ResultWidget({
    Key? key,
    required this.dropdownList,
    required this.resultOptions,
    required this.dropdownOptions,
    required this.dropdownItemOptions,
    required this.dropdownArrowOptions,
    required this.controller,
    required this.onChange,
    this.onOpen,
    this.defaultItem,
    this.isResultIconLabel = true,
    this.isResultLabel = true,
    this.isDropdownLabel = true,
    this.resultIconRotation = true,
  }) : super(key: key);

  @override
  State<ResultWidget<T>> createState() => _ResultWidgetState<T>();
}

class _ResultWidgetState<T> extends State<ResultWidget<T>> {
  final resultKey = GlobalKey();
  CoolDropdownItem<T>? selectedItem;

  bool _isError = false;

  late final _decorationBoxTween = DecorationTween(
    begin: widget.resultOptions.boxDecoration,
    end: widget.resultOptions.openBoxDecoration,
  ).animate(widget.controller.resultBox);

  @override
  void initState() {
    if (widget.defaultItem != null) {
      _setSelectedItem(widget.defaultItem!);
    }

    widget.controller.setFunctions(onError, widget.onOpen);
    widget.controller.setResultOptions(widget.resultOptions);

    super.initState();
  }

  void onError(bool value) {
    setState(() {
      _isError = value;
    });
  }

  void open() {
    print('object');
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

  Widget _buildArrow() {
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

  List<Widget> _buildResultItem() => [
        /// if you want to show icon in result widget
        if (widget.resultOptions.render == ResultRender.all ||
            widget.resultOptions.render == ResultRender.label ||
            widget.resultOptions.render == ResultRender.reverse)
          Text(
            selectedItem?.label ?? widget.resultOptions.placeholder ?? '',
            overflow: TextOverflow.ellipsis,
            style: selectedItem != null
                ? widget.resultOptions.textStyle
                : widget.resultOptions.placeholderTextStyle,
          ),

        /// if you want to show label in result widget
        if (widget.resultOptions.render == ResultRender.all ||
            widget.resultOptions.render == ResultRender.icon ||
            widget.resultOptions.render == ResultRender.reverse)
          selectedItem?.icon ?? const SizedBox(),

        /// if you want to show icon + label in result widget
      ].isReverse(widget.dropdownItemOptions.isReverse);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => open(),
      child: AnimatedBuilder(
          animation: Listenable.merge([
            widget.controller.controller,
            widget.controller.errorController
          ]),
          builder: (_, __) {
            return Container(
              key: resultKey,
              width: widget.resultOptions.width,
              height: widget.resultOptions.height,
              padding: widget.resultOptions.padding,
              decoration: _isError
                  ? widget.controller.errorDecoration.value
                  : _decorationBoxTween.value,
              child: Align(
                alignment: widget.resultOptions.alignment,
                child: widget.resultOptions.render != ResultRender.none
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
                                children: _buildResultItem(),
                              ),
                            ),
                          ),
                          SizedBox(width: widget.resultOptions.space),
                          _buildArrow(),
                        ].isReverse(widget.resultOptions.render ==
                            ResultRender.reverse),
                      )
                    : _buildArrow(),
              ),
            );
          }),
    );
  }
}
