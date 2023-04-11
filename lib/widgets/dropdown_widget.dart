import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/customPaints/dropdown_shape_border.dart';
import 'package:cool_dropdown/enums/dropdown_align.dart';
import 'package:cool_dropdown/enums/dropdown_animation.dart';
import 'package:cool_dropdown/enums/dropdown_arrow_align.dart';
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
  var isTap = false;

  final _scrollController = ScrollController();
  late int currentIndex = 0;

  var isArrowDown = true;

  double? calcDropdownHeight;

  @override
  void initState() {
    // currentIndex = widget.dropdownList.indexWhere(
    //     (dropdownItem) => mapEquals(dropdownItem, widget.selectedItem));
    _setOffset();
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

  void _setOffset() {
    final resultBox =
        widget.resultKey.currentContext?.findRenderObject() as RenderBox;
    final resultOffset = resultBox.localToGlobal(Offset.zero);
    dropdownOffset = Offset(
      _setOffsetDx(resultBox: resultBox, resultOffset: resultOffset),
      _setOffsetDy(resultBox: resultBox, resultOffset: resultOffset),
    );
  }

  double _setOffsetDx({
    required RenderBox resultBox,
    required Offset resultOffset,
  }) {
    switch (widget.dropdownOptions.align) {
      case DropdownAlign.left:
        return resultOffset.dx;
      case DropdownAlign.right:
        return resultOffset.dx +
            resultBox.size.width -
            widget.dropdownOptions.width;
      case DropdownAlign.center:
        return resultOffset.dx +
            (resultBox.size.width - widget.dropdownOptions.width) * 0.5;
    }
  }

  double _setOffsetDy({
    required RenderBox resultBox,
    required Offset resultOffset,
  }) {
    final screenHeight = MediaQuery.of(widget.bodyContext).size.height;
    final resultOffsetCenterDy = resultOffset.dy + resultBox.size.height * 0.5;

    isArrowDown = resultOffsetCenterDy > screenHeight * 0.5;

    if (isArrowDown) {
      /// set dropdown height not to overflow screen
      if (resultOffset.dy - widget.dropdownOptions.height < 0) {
        calcDropdownHeight = resultOffset.dy;
        return 0;
      }
      return resultOffset.dy - widget.dropdownOptions.height;
    } else {
      /// set dropdown height not to overflow screen
      if (resultOffset.dy +
              resultBox.size.height +
              widget.dropdownOptions.height >
          screenHeight) {
        calcDropdownHeight =
            screenHeight - (resultOffset.dy + resultBox.size.height);
      }
      return resultOffset.dy + resultBox.size.height;
    }
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

  double get _calcArrowAlignmentDx {
    switch (widget.dropdownArrowOptions.arrowAlign) {
      case DropdownArrowAlign.left:
        if (isArrowDown) {
          return ((widget.dropdownOptions.borderRadius.topLeft.x +
                      widget.dropdownArrowOptions.width * 0.5) /
                  widget.dropdownOptions.width) -
              1;
        } else {
          return ((widget.dropdownOptions.borderRadius.bottomLeft.x +
                      widget.dropdownArrowOptions.width * 0.5) /
                  widget.dropdownOptions.width) -
              1;
        }
      case DropdownArrowAlign.right:
        if (isArrowDown) {
          return (widget.dropdownOptions.width -
                  widget.dropdownOptions.borderRadius.topRight.x -
                  widget.dropdownArrowOptions.width * 0.5) /
              widget.dropdownOptions.width;
        } else {
          return (widget.dropdownOptions.width -
                  widget.dropdownOptions.borderRadius.bottomRight.x -
                  widget.dropdownArrowOptions.width * 0.5) /
              widget.dropdownOptions.width;
        }
      case DropdownArrowAlign.center:
        return 0;
    }
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
          alignment: Alignment(_calcArrowAlignmentDx, isArrowDown ? 1 : -1),
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
                    top: isArrowDown
                        ? 0
                        : widget.dropdownArrowOptions.height +
                            widget.dropdownOptions.borderSide.width,
                    bottom: isArrowDown
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
                      isArrowDown: isArrowDown,
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
