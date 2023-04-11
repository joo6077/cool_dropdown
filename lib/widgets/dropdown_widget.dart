import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/customPaints/dropdown_shape_border.dart';
import 'package:cool_dropdown/enums/dropdown_align.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_arrow_options.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:cool_dropdown/widgets/dropdown_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:cool_dropdown/utils/animation_util.dart';

class DropdownWidget<T> extends StatefulWidget {
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownArrowOptions dropdownArrowOptions;
  final DropdownController controller;

  final GlobalKey resultKey;
  final Function closeDropdown;
  final BuildContext bodyContext;

  final List<CoolDropdownItem> dropdownList;
  final List dropdownIsSelected = [];
  final Function onChange;
  final Function getSelectedItem;
  final bool isResultLabel;
  final bool isDropdownLabel;
  final CoolDropdownItem<T>? selectedItem;
  late Widget dropdownIcon;

  final double labelIconGap;

  DropdownWidget({
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
  }) {
    // // dropdown list 초기화
    // for (var i = 0; i < this.dropdownList.length; i++) {
    //   this.dropdownIsSelected.add(false);
    // }
    // // 삼각형 border 셋팅
    // this.triangleBorder = this.dropdownBD.border != null
    //     ? this.dropdownBD.border!.top
    //     : BorderSide(
    //         color: Colors.transparent,
    //         width: 0,
    //         style: BorderStyle.none,
    //       );
    // // 그림자 셋팅
    // triangleBoxShadows = this.dropdownBD.boxShadow ?? [];
    // // screenHeight 셋팅
    // this.screenHeight = MediaQuery.of(this.bodyContext).size.height;
    // // dropdownWidth setting
    // this.dropdownWidth = this.dropdownWidth ?? this.resultWidth;
  }

  @override
  DropdownWidgetState createState() => DropdownWidgetState();
}

class DropdownWidgetState extends State<DropdownWidget>
    with TickerProviderStateMixin {
  var dropdownOffset = Offset(0, 0);
  var selectedLabel = '';
  var isOpen = false;
  var isSelected = false;
  var isTap = false;

  final _scrollController = ScrollController();
  List<Animation> _swicherController = [];
  late int currentIndex = 0;

  bool isArrowDown = true;

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
              child: SizeTransition(
                sizeFactor: widget.controller.showDropdown,
                axisAlignment: -1,
                // scale: _dropdownController.showDropdown,
                // alignment:
                //     Alignment((400 - widget.arrow.height * 0.5 - 16) / 400, -1),
                child: Container(
                  margin: widget.dropdownOptions.marginGap,
                  // EdgeInsets.only(
                  // top: borderWidth + shadowBlur + shadowSpread > 0,
                  // ),
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
