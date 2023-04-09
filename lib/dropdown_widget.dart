import 'package:cool_dropdown/customPaint/dropdown_shape_border.dart';
import 'package:cool_dropdown/enums/dropdown_align.dart';
import 'package:cool_dropdown/enums/dropdown_arrow_align.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:cool_dropdown/utils/animation_util.dart';

class DropdownWidget<T> extends StatefulWidget {
  final Key key;
  final GlobalKey inputKey;
  final Function closeDropdown;
  final BuildContext bodyContext;
  late double screenHeight;

  final List dropdownList;
  final List dropdownIsSelected = [];
  final Function onChange;
  final Function getSelectedItem;
  final bool isTriangle;
  final bool isResultLabel;
  final bool isDropdownLabel;
  final CoolDropdownItem<T>? selectedItem;
  late Widget dropdownIcon;
  final bool isAnimation;

  // size
  final double resultWidth;
  final double resultHeight;
  late double? dropdownWidth;
  final double dropdownHeight;
  final double dropdownItemHeight;
  final double triangleWidth;
  final double triangleHeight;

  // align
  final Alignment resultAlign;
  final DropdownAlign dropdownAlign;
  final Alignment dropdownItemAlign;
  final DropdownArrowAlign triangleAlign;
  final double triangleLeft;
  final bool dropdownItemReverse;
  final MainAxisAlignment dropdownItemMainAxis;

  // padding
  final EdgeInsets dropdownItemPadding;
  final EdgeInsets dropdownPadding;
  final EdgeInsets selectedItemPadding;

  // style
  final BoxDecoration resultBD;
  final BoxDecoration dropdownBD;
  final BoxDecoration selectedItemBD;
  late BorderSide triangleBorder;
  final TextStyle selectedItemTS;
  final TextStyle unselectedItemTS;

  // gap
  final double gap;
  final double labelIconGap;
  final double dropdownItemGap;
  final double dropdownItemTopGap;
  final double dropdownItemBottomGap;

  // triangleBox Shadow
  late List triangleBoxShadows;

  final DropdownArrow arrow = const DropdownArrow(
    width: 30.0,
    height: 20.0,
    borderRadius: .0,
  );

  DropdownWidget(
      {required this.key,
      required this.inputKey,
      required this.dropdownList,
      required this.onChange,
      required this.closeDropdown,
      required this.getSelectedItem,
      required this.selectedItem,
      required this.dropdownItemReverse,
      required this.isTriangle,
      required this.resultWidth,
      required this.resultHeight,
      this.dropdownWidth,
      required this.dropdownHeight,
      required this.dropdownItemHeight,
      required this.resultAlign,
      required this.dropdownAlign,
      required this.triangleAlign,
      required this.dropdownItemAlign,
      required this.dropdownItemMainAxis,
      required this.dropdownItemPadding,
      required this.dropdownPadding,
      required this.selectedItemPadding,
      required this.resultBD,
      required this.dropdownBD,
      required this.selectedItemBD,
      required this.selectedItemTS,
      required this.unselectedItemTS,
      required this.labelIconGap,
      required this.dropdownItemGap,
      required this.dropdownItemTopGap,
      required this.dropdownItemBottomGap,
      required this.gap,
      required this.triangleWidth,
      required this.triangleHeight,
      required this.isAnimation,
      required this.isResultLabel,
      required this.bodyContext,
      required this.isDropdownLabel,
      required this.triangleLeft}) {
    // dropdown list 초기화
    for (var i = 0; i < this.dropdownList.length; i++) {
      this.dropdownIsSelected.add(false);
    }
    // 삼각형 border 셋팅
    this.triangleBorder = this.dropdownBD.border != null
        ? this.dropdownBD.border!.top
        : BorderSide(
            color: Colors.transparent,
            width: 0,
            style: BorderStyle.none,
          );
    // 그림자 셋팅
    triangleBoxShadows = this.dropdownBD.boxShadow ?? [];
    // screenHeight 셋팅
    this.screenHeight = MediaQuery.of(this.bodyContext).size.height;
    // dropdownWidth setting
    this.dropdownWidth = this.dropdownWidth ?? this.resultWidth;
  }

  @override
  DropdownWidgetState createState() => DropdownWidgetState();
}

class DropdownWidgetState extends State<DropdownWidget>
    with TickerProviderStateMixin {
  Offset dropdownOffset = Offset(0, 0);
  String selectedLabel = '';
  bool isOpen = false;
  bool isSelected = false;
  bool isTap = false;
  bool upsideDown = false;
  late bool isTop;
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late AnimationController _triangleController;
  List<AnimationController> _DCController = [];
  List<AnimationController> _paddingController = [];
  List<Animation> _swicherController = [];
  List<Animation<EdgeInsets>> _paddingAnimation = [];
  late Animation<double> animateHeight;
  late Animation<double> triangleAnimation;
  late Animation<double> selectedItemAnimation;
  late DecorationTween selectedDecorationTween;
  late TextStyleTween selectedTSTween;
  late EdgeInsetsTween selectedPaddingTween;
  late int currentIndex = 0;
  AnimationUtil au = AnimationUtil();

  @override
  void initState() {
    // currentIndex = widget.dropdownList.indexWhere(
    //     (dropdownItem) => mapEquals(dropdownItem, widget.selectedItem));
    // setOffset();
    // setAnimation();
    // setScrollPosition(currentIndex);

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  void setOffset() {
    // inputBox info
    dynamic inputBox = widget.inputKey.currentContext!.findRenderObject();
    Offset inputPosition = inputBox!.localToGlobal(Offset.zero);

    double actualBoxHeight = widget.dropdownHeight +
        widget.dropdownPadding.top +
        widget.dropdownPadding.bottom;
    double inputCenterPosition =
        inputPosition.dy + (inputBox.size.height * 0.5);
    double sidePadding =
        widget.dropdownPadding.right + widget.dropdownPadding.left;
    isTop = (inputCenterPosition < widget.screenHeight * 0.5);

    if (isTop) {
      // position dropbox top
      dropdownOffset = setDropdownPosition(
          isTop: true,
          sidePadding: sidePadding,
          inputBox: inputBox,
          inputPosition: inputPosition,
          actualBoxHeight: actualBoxHeight);

      if (widget.screenHeight < actualBoxHeight + dropdownOffset.dy) {
        setState(() {
          // widget.dropdownHeight = widget.screenHeight - dropdownOffset.dy - 10;
        });
      }
    } else {
      // position dropbox bottom
      dropdownOffset = setDropdownPosition(
          isTop: false,
          sidePadding: sidePadding,
          inputBox: inputBox,
          inputPosition: inputPosition,
          actualBoxHeight: actualBoxHeight);
      setState(() {
        // triangle upsideDown
        upsideDown = true;
        double extraHeight = widget.screenHeight -
            (widget.screenHeight - inputPosition.dy) -
            widget.gap -
            10;
        if (widget.dropdownHeight > extraHeight) {
          // widget.dropdownHeight = extraHeight;
          dropdownOffset = Offset(dropdownOffset.dx, 10);
        }
      });
    }
  }

  void setAnimation() {
    // dropdown height
    _animationController = AnimationController(
      duration: au.isAnimation(
          status: widget.isAnimation, duration: Duration(milliseconds: 100)),
      vsync: this,
    );
    _triangleController = AnimationController(
      duration: au.isAnimation(
          status: widget.isAnimation, duration: Duration(milliseconds: 50)),
      vsync: this,
    );
    Animation<double> curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    animateHeight =
        Tween<double>(begin: 0, end: widget.dropdownHeight).animate(curve);
    triangleAnimation = CurvedAnimation(
      parent: _triangleController,
      curve: Curves.easeIn,
    );
    // each of items animation
    for (var i = 0; i < widget.dropdownIsSelected.length; i++) {
      AnimationController animationControllerElement = AnimationController(
          vsync: this,
          duration: au.isAnimation(
              status: widget.isAnimation,
              duration: Duration(milliseconds: 300)));
      _DCController.add(
          animationControllerElement); // selected, unselected decorationBox, textStyle
      _paddingController.add(animationControllerElement);
      _paddingAnimation.add(EdgeInsetsTween(
              begin: widget.dropdownItemPadding,
              end: widget.selectedItemPadding)
          .animate(CurvedAnimation(
              parent: _paddingController[i], curve: Curves.easeIn)));
    }
    selectedDecorationTween = DecorationTween(
        begin: BoxDecoration(color: Colors.transparent),
        end: widget.selectedItemBD);
    selectedTSTween = TextStyleTween(
        begin: widget.unselectedItemTS, end: widget.selectedItemTS);
  }

  void setScrollPosition(int currentIndex) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await animationForward();
      if (currentIndex != -1) {
        double totalHeight = widget.dropdownList.length *
                (widget.dropdownItemHeight + widget.dropdownItemGap) +
            widget.dropdownItemTopGap +
            widget.dropdownItemBottomGap;
        double scrollPosition = currentIndex *
                (widget.dropdownItemHeight + widget.dropdownItemGap) +
            widget.dropdownItemTopGap -
            widget.dropdownItemGap;
        double overScrollPosition = ((widget.dropdownItemHeight *
                    widget.dropdownList.length) +
                (widget.dropdownItemGap * (widget.dropdownList.length - 1)) +
                widget.dropdownItemTopGap) -
            widget.dropdownHeight +
            widget.dropdownItemBottomGap;
        if (currentIndex == 0) {
          scrollPosition = 0;
        }
        if (overScrollPosition < scrollPosition) {
          scrollPosition = overScrollPosition;
        }
        if (totalHeight < widget.dropdownHeight) {
          scrollPosition = 0;
        }
        _scrollController.animateTo(scrollPosition,
            duration: au.isAnimation(
                status: widget.isAnimation,
                duration: Duration(milliseconds: 300)),
            curve: Curves.easeInOut);

        setState(() {
          widget.dropdownIsSelected[currentIndex] = true;
        });

        _DCController[currentIndex].forward();
        _paddingController[currentIndex].forward();
      }
    });
  }

  Future animationForward() async {
    if (isTop) {
      await _triangleController.forward();
      _animationController.forward();
    } else {
      await _animationController.forward();
      _triangleController.forward();
    }
  }

  Future animationReverse() async {
    if (isTop) {
      await _animationController.reverse();
      return _triangleController.reverse();
    } else {
      await _triangleController.reverse();
      return _animationController.reverse();
    }
  }

  Offset setDropdownPosition(
      {required bool isTop,
      required double sidePadding,
      required dynamic inputBox,
      required Offset inputPosition,
      required double actualBoxHeight}) {
    double value = 0;

    switch (widget.dropdownAlign) {
      case DropdownAlign.left:
        value = 0;
        break;
      case DropdownAlign.right:
        value = inputBox.size.width -
            (widget.dropdownWidth! + sidePadding) -
            widget.triangleBorder.width * 2;
        break;
      case DropdownAlign.center:
        value = (inputBox.size.width - (widget.dropdownWidth! + sidePadding)) *
                0.5 -
            widget.triangleBorder.width;
        break;
    }
    return Offset(
        inputPosition.dx + value,
        isTop
            ? inputPosition.dy + inputBox.size.height + widget.gap
            : inputPosition.dy - (widget.gap + actualBoxHeight));
  }

  void closeAnimation() {}

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      top: 100,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 200,
          height: 400,
          decoration: ShapeDecoration(
            color: Colors.white,
            shadows: [
              // BoxShadow(
              //   color: Colors.black,
              //   blurRadius: 10,
              //   spreadRadius: 5,
              //   offset: Offset(10, 0),
              // )
            ],
            shape: DropdownShapeBorder(
              // radius: 10,
              // arrowHeight: 20,
              arrow: widget.arrow,
              isArrowDown: true,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Text('data'),
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
