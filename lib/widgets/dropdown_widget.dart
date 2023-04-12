import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/controllers/dropdown_calculator.dart';
import 'package:cool_dropdown/customPaints/dropdown_shape_border.dart';
import 'package:cool_dropdown/enums/dropdown_animation.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_arrow_options.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:cool_dropdown/widgets/dropdown_item_widget.dart';
import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatefulWidget {
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownArrowOptions dropdownArrowOptions;
  final DropdownController controller;

  final GlobalKey resultKey;
  final Function closeDropdown;
  final BuildContext bodyContext;

  final List<CoolDropdownItem> dropdownList;
  final Function onChange;
  final Function getSelectedItem;
  final bool isResultLabel;
  final bool isDropdownLabel;
  final CoolDropdownItem<T>? selectedItem;

  final double labelIconGap;

  const DropdownWidget({
    Key? key,
    required this.dropdownOptions,
    required this.dropdownItemOptions,
    required this.dropdownArrowOptions,
    required this.controller,
    required this.resultKey,
    required this.dropdownList,
    required this.onChange,
    required this.closeDropdown,
    required this.getSelectedItem,
    required this.selectedItem,
    required this.labelIconGap,
    required this.isResultLabel,
    required this.bodyContext,
    required this.isDropdownLabel,
  });

  @override
  DropdownWidgetState createState() => DropdownWidgetState();
}

class DropdownWidgetState extends State<DropdownWidget> {
  var dropdownOffset = Offset(0, 0);
  var selectedLabel = '';
  var isOpen = false;
  var isSelected = false;

  final _scrollController = ScrollController();
  late int currentIndex = 0;

  double? calcDropdownHeight;

  late final DropdownCalculator _dropdownCalculator;

  @override
  void initState() {
    // currentIndex = widget.dropdownList.indexWhere(
    //     (dropdownItem) => mapEquals(dropdownItem, widget.selectedItem));
    _dropdownCalculator = DropdownCalculator(
        bodyContext: widget.bodyContext,
        resultKey: widget.resultKey,
        dropdownOptions: widget.dropdownOptions,
        dropdownArrowOptions: widget.dropdownArrowOptions);

    dropdownOffset = _dropdownCalculator.setOffset();
    // setScrollPosition(currentIndex);

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  void setScrollPosition(int currentIndex) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // if (currentIndex != -1) {
      //   double totalHeight = widget.dropdownList.length *
      //           (widget.dropdownItemHeight + widget.dropdownItemGap) +
      //       widget.dropdownItemTopGap +
      //       widget.dropdownItemBottomGap;
      //   double scrollPosition = currentIndex *
      //           (widget.dropdownItemHeight + widget.dropdownItemGap) +
      //       widget.dropdownItemTopGap -
      //       widget.dropdownItemGap;
      //   double overScrollPosition = ((widget.dropdownItemHeight *
      //               widget.dropdownList.length) +
      //           (widget.dropdownItemGap * (widget.dropdownList.length - 1)) +
      //           widget.dropdownItemTopGap) -
      //       widget.dropdownHeight +
      //       widget.dropdownItemBottomGap;
      //   if (currentIndex == 0) {
      //     scrollPosition = 0;
      //   }
      //   if (overScrollPosition < scrollPosition) {
      //     scrollPosition = overScrollPosition;
      //   }
      //   if (totalHeight < widget.dropdownHeight) {
      //     scrollPosition = 0;
      //   }
      //   _scrollController.animateTo(scrollPosition,
      //       duration: au.isAnimation(
      //           status: widget.isAnimation,
      //           duration: Duration(milliseconds: 300)),
      //       curve: Curves.easeInOut);

      //   setState(() {
      //     widget.dropdownIsSelected[currentIndex] = true;
      //   });

      //   _DCController[currentIndex].forward();
      //   _paddingController[currentIndex].forward();
      // }
    });
  }

  void _setSelectedItem(int index) {
    setState(() {
      for (var i = 0; i < widget.dropdownList.length; i++) {
        if (index == i) {
          widget.dropdownList[i] =
              widget.dropdownList[i].copyWith(isSelected: true);
        } else {
          widget.dropdownList[i] =
              widget.dropdownList[i].copyWith(isSelected: false);
        }
      }
    });
  }

  Widget _buildAnimation({required Widget child}) {
    switch (widget.dropdownOptions.animationType) {
      case DropdownAnimationType.size:
        return SizeTransition(
          sizeFactor: widget.controller.showDropdown,
          axisAlignment: -1,
          child: child,
        );
      case DropdownAnimationType.scale:
        return ScaleTransition(
          scale: widget.controller.showDropdown,
          alignment: Alignment(_dropdownCalculator.calcArrowAlignmentDx,
              _dropdownCalculator.isArrowDown ? 1 : -1),
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => widget.controller.close(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            top: dropdownOffset.dy - widget.dropdownOptions.marginGap.top,
            left: dropdownOffset.dx - widget.dropdownOptions.marginGap.left,
            child: GestureDetector(
              onTap: () {},
              child: _buildAnimation(
                child: Container(
                  margin: widget.dropdownOptions.marginGap,
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.only(
                    top: _dropdownCalculator.isArrowDown
                        ? 0
                        : widget.dropdownArrowOptions.height +
                            widget.dropdownOptions.borderSide.width,
                    bottom: _dropdownCalculator.isArrowDown
                        ? widget.dropdownArrowOptions.height +
                            widget.dropdownOptions.borderSide.width
                        : 0,
                  ),
                  width: widget.dropdownOptions.width,
                  height: calcDropdownHeight ?? widget.dropdownOptions.height,
                  decoration: ShapeDecoration(
                    color: widget.dropdownOptions.color,
                    shadows: widget.dropdownOptions.shadows,
                    shape: DropdownShapeBorder(
                      arrow: widget.dropdownArrowOptions,
                      radius: widget.dropdownOptions.borderRadius,
                      borderSide: widget.dropdownOptions.borderSide,
                      arrowAlign: widget.dropdownArrowOptions.arrowAlign,
                      isArrowDown: _dropdownCalculator.isArrowDown,
                    ),
                  ),
                  child: ListView.builder(
                    padding: widget.dropdownOptions.calcPadding,
                    itemCount: widget.dropdownList.length,
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () => _setSelectedItem(index),
                      child: Column(
                        children: [
                          if (index == 0)
                            SizedBox(
                              height: widget.dropdownOptions.gap.top,
                            ),
                          DropdownItemWidget(
                            item: widget.dropdownList[index],
                            dropdownItemOptions: widget.dropdownItemOptions,
                          ),
                          if (index != widget.dropdownList.length - 1)
                            SizedBox(
                              height:
                                  widget.dropdownOptions.gap.gapBetweenItems,
                            ),
                          if (index == widget.dropdownList.length - 1)
                            SizedBox(
                              height: widget.dropdownOptions.gap.bottom,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
