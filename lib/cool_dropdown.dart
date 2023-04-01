library cool_dropdown;

import 'package:cool_dropdown/enums/triangle_align.dart';
import 'package:cool_dropdown/enums/dropdown_align.dart';
import 'package:flutter/material.dart';
import 'package:cool_dropdown/utils/animation_util.dart';
import 'package:cool_dropdown/utils/extension_util.dart';
import 'package:cool_dropdown/dropdown_body.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';

class CoolDropdown<T> extends StatefulWidget {
  final List<CoolDropdownItem<T>> dropdownList;
  final Function onChange;
  final Function? onOpen;
  final String placeholder;
  // final Map? defaultValue;
  final bool isTriangle;
  final bool isAnimation;
  final bool isResultIconLabel;
  final bool isResultLabel;
  final bool isDropdownLabel; // late
  final bool resultIconRotation;
  final Widget? resultIcon;
  final double resultIconRotationValue;

  // size
  final double resultWidth;
  final double resultHeight;
  final double? dropdownWidth; // late
  final double dropdownHeight; // late
  final double dropdownItemHeight;
  final double triangleWidth;
  final double triangleHeight;
  final double iconSize;

  // align
  final Alignment resultAlign;
  final DropdownAlign dropdownAlign; // late
  final Alignment dropdownItemAlign;
  final DropdownArrowAlign triangleAlign;
  final double triangleLeft;
  final bool dropdownItemReverse;
  final bool resultReverse;
  final MainAxisAlignment resultMainAxis;
  final MainAxisAlignment dropdownItemMainAxis;

  // padding
  final EdgeInsets resultPadding;
  final EdgeInsets dropdownItemPadding;
  final EdgeInsets dropdownPadding; // late
  final EdgeInsets selectedItemPadding;

  // style
  late final BoxDecoration resultBD;
  late final BoxDecoration dropdownBD; // late
  late final BoxDecoration selectedItemBD;
  late final TextStyle selectedItemTS;
  late final TextStyle unselectedItemTS;
  late final TextStyle resultTS;
  late final TextStyle placeholderTS;

  // gap
  final double gap;
  final double labelIconGap;
  final double dropdownItemGap;
  final double dropdownItemTopGap;
  final double dropdownItemBottomGap;
  final double resultIconLeftGap;

  CoolDropdown({
    required this.dropdownList,
    required this.onChange,
    this.onOpen,
    this.resultIcon,
    placeholderTS,
    this.dropdownItemReverse = false,
    this.resultReverse = false,
    this.resultIconRotation = true,
    this.isTriangle = true,
    this.isResultLabel = true,
    this.placeholder = '',
    this.resultWidth = 220,
    this.resultHeight = 50,
    this.dropdownWidth,
    this.dropdownHeight = 300,
    this.dropdownItemHeight = 50,
    this.resultAlign = Alignment.centerLeft,
    this.dropdownAlign = DropdownAlign.center,
    this.triangleAlign = DropdownArrowAlign.center,
    this.dropdownItemAlign = Alignment.centerLeft,
    this.dropdownItemMainAxis = MainAxisAlignment.spaceBetween,
    this.resultMainAxis = MainAxisAlignment.spaceBetween,
    this.resultPadding = const EdgeInsets.only(left: 10, right: 10),
    this.dropdownItemPadding = const EdgeInsets.only(left: 10, right: 10),
    this.dropdownPadding = const EdgeInsets.only(left: 10, right: 10),
    this.selectedItemPadding = const EdgeInsets.only(left: 10, right: 10),
    resultBD,
    dropdownBD,
    selectedItemBD,
    selectedItemTS,
    unselectedItemTS,
    resultTS,
    this.labelIconGap = 10,
    this.dropdownItemGap = 5,
    this.dropdownItemTopGap = 10,
    this.dropdownItemBottomGap = 10,
    this.resultIconLeftGap = 10,
    this.gap = 30,
    this.triangleWidth = 20,
    this.triangleHeight = 20,
    this.triangleLeft = 0,
    this.isAnimation = true,
    this.isResultIconLabel = true,
    this.resultIconRotationValue = 0.5,
    this.isDropdownLabel = true,
    this.iconSize = 10,
    defaultValue,
  }) {
    // box decoration 셋팅
    this.resultBD = resultBD ??
        BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        );
    this.dropdownBD = dropdownBD ??
        BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
          ],
        );
    this.selectedItemBD = selectedItemBD ??
        BoxDecoration(
          color: Color(0XFFEFFAF0),
          borderRadius: BorderRadius.circular(10),
        );
    // text style 셋팅
    this.selectedItemTS =
        selectedItemTS ?? TextStyle(color: Color(0xFF6FCC76), fontSize: 20);
    this.unselectedItemTS = unselectedItemTS != null
        ? unselectedItemTS
        : TextStyle(
            fontSize: 20,
            color: Colors.black,
          );
    this.resultTS = resultTS ??
        TextStyle(
          fontSize: 20,
          color: Colors.black,
        );
    this.placeholderTS = placeholderTS ??
        TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 20);
    // Icon Container 셋팅
    // this.resultIcon = resultIcon ??
    //     Container(
    //       width: this.iconSize,
    //       height: this.iconSize,
    //       child: CustomPaint(
    //         size: Size(
    //             this.iconSize * 0.01, (this.iconSize * 0.01 * 1).toDouble()),
    //         painter: DropdownArrow(),
    //       ),
    //     );
  }

  @override
  _CoolDropdownState createState() => _CoolDropdownState();
}

class _CoolDropdownState<T> extends State<CoolDropdown>
    with TickerProviderStateMixin {
  GlobalKey<DropdownBodyState> dropdownBodyChild = GlobalKey();
  GlobalKey inputKey = GlobalKey();
  Offset triangleOffset = Offset(0, 0);
  late OverlayEntry _overlayEntry;
  CoolDropdownItem<T>? selectedItem;
  late AnimationController rotationController;
  late AnimationController sizeController;
  late Animation<double> textWidth;
  AnimationUtil au = AnimationUtil();
  late bool isOpen = false;

  void openDropdown() {
    isOpen = true;
    if (widget.onOpen != null) {
      widget.onOpen!(isOpen);
    }
    this._overlayEntry = this._createOverlayEntry();
    Overlay.of(inputKey.currentContext!).insert(this._overlayEntry);
    rotationController.forward();
  }

  void closeDropdown() {
    isOpen = false;
    if (widget.onOpen != null) {
      widget.onOpen!(isOpen);
    }
    this._overlayEntry.remove();
    rotationController.reverse();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (BuildContext context) => DropdownBody<T>(
        key: dropdownBodyChild,
        inputKey: inputKey,
        onChange: widget.onChange,
        dropdownList: widget.dropdownList,
        dropdownItemReverse: widget.dropdownItemReverse,
        isTriangle: widget.isTriangle,
        resultWidth: widget.resultWidth,
        resultHeight: widget.resultHeight,
        dropdownWidth: widget.dropdownWidth,
        dropdownHeight: widget.dropdownHeight,
        dropdownItemHeight: widget.dropdownItemHeight,
        resultAlign: widget.resultAlign,
        dropdownAlign: widget.dropdownAlign,
        triangleAlign: widget.triangleAlign,
        dropdownItemAlign: widget.dropdownItemAlign,
        dropdownItemPadding: widget.dropdownItemPadding,
        dropdownPadding: widget.dropdownPadding,
        selectedItemPadding: widget.selectedItemPadding,
        resultBD: widget.resultBD,
        dropdownBD: widget.dropdownBD,
        selectedItemBD: widget.selectedItemBD,
        selectedItemTS: widget.selectedItemTS,
        unselectedItemTS: widget.unselectedItemTS,
        dropdownItemGap: widget.dropdownItemGap,
        dropdownItemTopGap: widget.dropdownItemTopGap,
        dropdownItemBottomGap: widget.dropdownItemBottomGap,
        gap: widget.gap,
        labelIconGap: widget.labelIconGap,
        triangleWidth: widget.triangleWidth,
        triangleHeight: widget.triangleHeight,
        triangleLeft: widget.triangleLeft,
        isResultLabel: widget.isResultLabel,
        closeDropdown: () {
          closeDropdown();
        },
        getSelectedItem: (selectedItem) async {
          sizeController = AnimationController(
            vsync: this,
            duration: au.isAnimation(
                status: widget.isAnimation,
                duration: Duration(milliseconds: 150)),
          );
          textWidth = CurvedAnimation(
            parent: sizeController,
            curve: Curves.fastOutSlowIn,
          );
          setState(() {
            this.selectedItem = selectedItem;
          });
          await sizeController.forward();
        },
        selectedItem: selectedItem,
        isAnimation: widget.isAnimation,
        dropdownItemMainAxis: widget.dropdownItemMainAxis,
        bodyContext: context,
        isDropdownLabel: widget.isDropdownLabel,
      ),
    );
  }

  @override
  void initState() {
    rotationController = AnimationController(
        duration: au.isAnimation(
            status: widget.isAnimation, duration: Duration(milliseconds: 150)),
        vsync: this);
    sizeController = AnimationController(
        vsync: this,
        duration: au.isAnimation(
            status: widget.isAnimation, duration: Duration(milliseconds: 150)));
    textWidth = CurvedAnimation(
      parent: sizeController,
      curve: Curves.fastOutSlowIn,
    );
    // placeholder 셋팅
    setDefaultValue();
    super.initState();
  }

  void setDefaultValue() {
    setState(() {
      sizeController = AnimationController(
        vsync: this,
        duration: au.isAnimation(status: false),
      );
      textWidth = CurvedAnimation(
        parent: sizeController,
        curve: Curves.fastOutSlowIn,
      );
      // this.selectedItem = widget.defaultValue;
      sizeController.forward();
    });
  }

  RotationTransition rotationIcon() {
    return RotationTransition(
        turns: Tween(begin: 0.0, end: widget.resultIconRotationValue).animate(
            CurvedAnimation(parent: rotationController, curve: Curves.easeIn)),
        child: widget.resultIcon ?? const SizedBox());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isOpen) {
          await dropdownBodyChild.currentState!.animationReverse();
          closeDropdown();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: GestureDetector(
        onTap: () {
          openDropdown();
        },
        child: Container(
          key: inputKey,
          width: widget.resultWidth,
          height: widget.resultHeight,
          padding: widget.resultPadding,
          decoration: widget.resultBD,
          child: Align(
            alignment: widget.resultAlign,
            child: widget.isResultIconLabel
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[
                      Expanded(
                        child: SizeTransition(
                          sizeFactor: textWidth,
                          axisAlignment: -1,
                          child: Row(
                            mainAxisAlignment: widget.resultMainAxis,
                            children: [
                              if (widget.isResultLabel)
                                Flexible(
                                  child: Container(
                                    child: Text(
                                      selectedItem?.label ?? widget.placeholder,
                                      overflow: TextOverflow.ellipsis,
                                      style: selectedItem != null
                                          ? widget.resultTS
                                          : widget.placeholderTS,
                                    ),
                                  ),
                                ),
                              if (widget.isResultLabel)
                                SizedBox(
                                  width: widget.labelIconGap,
                                ),
                              selectedItem?.icon ?? SizedBox(),
                            ].isReverse(widget.dropdownItemReverse),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: widget.resultIconLeftGap,
                      ),
                      widget.resultIconRotation
                          ? rotationIcon()
                          : widget.resultIcon!
                    ].isReverse(widget.resultReverse),
                  )
                : rotationIcon(),
          ),
        ),
      ),
    );
  }
}
