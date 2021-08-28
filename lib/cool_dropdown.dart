library cool_dropdown;
import 'package:flutter/material.dart';
import 'package:cool_dropdown/utils/animation_util.dart';
import 'package:cool_dropdown/utils/extension_util.dart';
import 'package:cool_dropdown/drop_down_body.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoolDropdown extends StatefulWidget {
  List dropdownList;
  Function onChange;
  String placeholder;
  late Map defaultValue;
  bool isTriangle;
  bool isAnimation;
  bool isDropdownIconLabel;
  bool isDropdownLabel;
  bool isDropdownBoxLabel;
  bool dropdownIconRotation;
  late Widget dropdownIcon;
  late Widget dropdownItemIcon;
  double dropdownIconRotationValue;

  // size
  double dropdownWidth;
  double dropdownHeight;
  double dropdownBoxWidth;
  double dropdownBoxHeight;
  double dropdownItemHeight;
  double triangleWidth;
  double triangleHeight;

  // align
  Alignment dropdownAlign;
  String dropdownBoxAlign;
  Alignment dropdownItemAlign;
  String triangleAlign;
  double triangleLeft;
  bool dropdownItemReverse;
  bool dropdownReverse;
  MainAxisAlignment dropdownMainAxis;
  MainAxisAlignment dropdownItemMainAxis;

  // padding
  EdgeInsets dropdownPadding;
  EdgeInsets dropdownItemPadding;
  EdgeInsets dropdownBoxPadding;
  EdgeInsets selectedItemPadding;

  // style
  late BoxDecoration dropdownBD;
  late BoxDecoration dropdownBoxBD;
  late BoxDecoration selectedItemBD;
  late TextStyle selectedItemTS;
  late TextStyle unselectedItemTS;
  late TextStyle dropdownTS;
  late TextStyle placeholderTS;

  // gap
  double gap;
  double labelIconGap;
  double dropdownItemGap;
  double dropdownItemTopGap;
  double dropdownItemBottomGap;
  double dropdownIconLeftGap;

  CoolDropdown(
      {required this.dropdownList,
      required this.onChange,
      dropdownIcon,
      placeholderTS,
      this.dropdownItemReverse = false,
      this.dropdownReverse = false,
      this.dropdownIconRotation = true,
      this.isTriangle = true,
      this.isDropdownLabel = true,
      this.placeholder = '',
      this.dropdownWidth = 220,
      this.dropdownHeight = 50,
      this.dropdownBoxWidth = 200,
      this.dropdownBoxHeight = 300,
      this.dropdownItemHeight = 50,
      this.dropdownAlign = Alignment.centerLeft,
      this.dropdownBoxAlign = 'center',
      this.triangleAlign = 'center',
      this.dropdownItemAlign = Alignment.centerLeft,
      this.dropdownItemMainAxis = MainAxisAlignment.spaceBetween,
      this.dropdownMainAxis = MainAxisAlignment.spaceBetween,
      this.dropdownPadding = const EdgeInsets.only(left: 10, right: 10),
      this.dropdownItemPadding = const EdgeInsets.only(left: 10, right: 10),
      this.dropdownBoxPadding = const EdgeInsets.only(left: 10, right: 10),
      this.selectedItemPadding = const EdgeInsets.only(left: 10, right: 10),
      dropdownBD,
      dropdownBoxBD,
      selectedItemBD,
      selectedItemTS,
      unselectedItemTS,
      dropdownTS,
      this.labelIconGap = 10,
      this.dropdownItemGap = 5,
      this.dropdownItemTopGap = 10,
      this.dropdownItemBottomGap = 10,
      this.dropdownIconLeftGap = 10,
      this.gap = 30,
      this.triangleWidth = 20,
      this.triangleHeight = 20,
      this.triangleLeft = 0,
      this.isAnimation = true,
      this.isDropdownIconLabel = true,
      this.dropdownIconRotationValue = 0.5,
      this.isDropdownBoxLabel = true,
      defaultValue}) {
    // 기본값 셋팅
    if (defaultValue != null) {
      print('.. $defaultValue');
      this.defaultValue = defaultValue;
    } else {
      this.defaultValue = {};
    }
    // label unique 체크
    for (var i = 0; i < dropdownList.length; i++) {
      if (dropdownList[i]['label'] == null) {
        throw '"label" must be initialized.';
      }
      for (var j = 0; j < dropdownList.length; j++) {
        if (i != j) {
          if (dropdownList[i]['label'] == dropdownList[j]['label']) {
            throw 'label is duplicated. Labels have to be unique.';
          }
        }
      }
    }
    // box decoration 셋팅
    this.dropdownBD = dropdownBD ??
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
    this.dropdownBoxBD = dropdownBoxBD ??
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
    this.dropdownTS = dropdownTS ??
        TextStyle(
          fontSize: 20,
          color: Colors.black,
        );
    this.placeholderTS = placeholderTS ??
        TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 20);
    // Icon Container 셋팅
    this.dropdownIcon = dropdownIcon != null
        ? dropdownIcon
        : Container(
            width: 10,
            height: 10,
            child: SvgPicture.asset(
              'assets/dropdown-arrow.svg',
              semanticsLabel: 'Acme Logo',
              color: Colors.grey.withOpacity(0.7),
            ),
          );
  }

  @override
  _CoolDropdownState createState() => _CoolDropdownState();
}

class _CoolDropdownState extends State<CoolDropdown> with TickerProviderStateMixin {
  GlobalKey inputKey = GlobalKey();
  Offset triangleOffset = Offset(0, 0);
  late OverlayEntry _overlayEntry;
  late Map selectedItem;
  late AnimationController rotationController;
  late AnimationController sizeController;
  late Animation<double> textWidth;
  AnimationUtil au = AnimationUtil();

  openDropdown() {
    this._overlayEntry = this._createOverlayEntry();
    Overlay.of(inputKey.currentContext!)!.insert(this._overlayEntry);
    rotationController.forward();
  }

  void closeDropdown() {
    this._overlayEntry.remove();
    rotationController.reverse();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: DropdownBody(
            inputKey: inputKey,
            onChange: widget.onChange,
            dropdownList: widget.dropdownList,
            dropdownItemReverse: widget.dropdownItemReverse,
            isTriangle: widget.isTriangle,
            dropdownWidth: widget.dropdownWidth,
            dropdownHeight: widget.dropdownHeight,
            dropdownBoxWidth: widget.dropdownBoxWidth,
            dropdownBoxHeight: widget.dropdownBoxHeight,
            dropdownItemHeight: widget.dropdownItemHeight,
            dropdownAlign: widget.dropdownAlign,
            dropdownBoxAlign: widget.dropdownBoxAlign,
            triangleAlign: widget.triangleAlign,
            dropdownItemAlign: widget.dropdownItemAlign,
            dropdownItemPadding: widget.dropdownItemPadding,
            dropdownBoxPadding: widget.dropdownBoxPadding,
            selectedItemPadding: widget.selectedItemPadding,
            dropdownBD: widget.dropdownBD,
            dropdownBoxBD: widget.dropdownBoxBD,
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
            isDropdownLabel: widget.isDropdownLabel,
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
            isDropdownBoxLabel: widget.isDropdownBoxLabel,
          ),
        ),
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
    setState(() {
      sizeController = AnimationController(
        vsync: this,
        duration: au.isAnimation(status: false),
      );
      textWidth = CurvedAnimation(
        parent: sizeController,
        curve: Curves.fastOutSlowIn,
      );
      this.selectedItem = widget.defaultValue;
      sizeController.forward();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openDropdown();
      },
      child: Stack(
        children: [
          Container(
            key: inputKey,
            width: widget.dropdownWidth,
            height: widget.dropdownHeight,
            padding: widget.dropdownPadding,
            decoration: widget.dropdownBD,
            child: Align(
              alignment: widget.dropdownAlign,
              child: widget.isDropdownIconLabel
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        Expanded(
                          child: SizeTransition(
                            sizeFactor: textWidth,
                            axisAlignment: -1,
                            child: Row(
                              mainAxisAlignment: widget.dropdownMainAxis,
                              children: [
                                if (widget.isDropdownLabel)
                                  Flexible(
                                    child: Container(
                                      child: Text(
                                        selectedItem['label'] ??
                                            widget.placeholder,
                                        overflow: TextOverflow.ellipsis,
                                        style: selectedItem['label'] != null
                                            ? widget.dropdownTS
                                            : widget.placeholderTS,
                                      ),
                                    ),
                                  ),
                                if (widget.isDropdownLabel)
                                  SizedBox(
                                    width: widget.labelIconGap,
                                  ),
                                selectedItem['icon'] != null
                                    ? selectedItem['icon'] as Widget
                                    : Container(),
                              ].isReverse(widget.dropdownItemReverse),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: widget.dropdownIconLeftGap,
                        ),
                        widget.dropdownIconRotation
                            ? rotationIcon()
                            : widget.dropdownIcon
                      ].isReverse(widget.dropdownReverse),
                    )
                  : rotationIcon(),
            ),
          ),
        ],
      ),
    );
  }

  RotationTransition rotationIcon() {
    return RotationTransition(
        turns: Tween(begin: 0.0, end: widget.dropdownIconRotationValue).animate(
            CurvedAnimation(
                parent: rotationController, curve: Curves.easeIn)),
        child: widget.dropdownIcon);
  }
}

