import 'package:cool_dropdown/enums/dropdown_align.dart';
import 'package:cool_dropdown/enums/dropdown_arrow_align.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_arrow_options.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:flutter/widgets.dart';

class DropdownCalculator<T> {
  final List<CoolDropdownItem<T>> dropdownList;
  final BuildContext bodyContext;
  final GlobalKey resultKey;
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownArrowOptions dropdownArrowOptions;

  final _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  bool _isArrowDown = false;
  bool get isArrowDown => _isArrowDown;

  double? _calcDropdownHeight;
  double? get calcDropdownHeight => _calcDropdownHeight;

  DropdownCalculator({
    required this.dropdownList,
    required this.bodyContext,
    required this.resultKey,
    required this.dropdownOptions,
    required this.dropdownItemOptions,
    required this.dropdownArrowOptions,
  });

  Offset setOffset() {
    final resultBox = resultKey.currentContext?.findRenderObject() as RenderBox;
    final resultOffset = resultBox.localToGlobal(Offset.zero);
    return Offset(
      _setOffsetDx(resultBox: resultBox, resultOffset: resultOffset),
      _setOffsetDy(resultBox: resultBox, resultOffset: resultOffset),
    );
  }

  double _setOffsetDx({
    required RenderBox resultBox,
    required Offset resultOffset,
  }) {
    switch (dropdownOptions.align) {
      case DropdownAlign.left:
        return resultOffset.dx;
      case DropdownAlign.right:
        return resultOffset.dx + resultBox.size.width - dropdownOptions.width;
      case DropdownAlign.center:
        return resultOffset.dx +
            (resultBox.size.width - dropdownOptions.width) * 0.5;
    }
  }

  double _setOffsetDy({
    required RenderBox resultBox,
    required Offset resultOffset,
  }) {
    final screenHeight = MediaQuery.of(bodyContext).size.height;
    final resultOffsetCenterDy = resultOffset.dy + resultBox.size.height * 0.5;

    _isArrowDown = resultOffsetCenterDy > screenHeight * 0.5;

    if (_isArrowDown) {
      /// set dropdown height not to overflow screen
      if (resultOffset.dy - dropdownOptions.height < 0) {
        _calcDropdownHeight = resultOffset.dy;
        return 0;
      }
      return resultOffset.dy - dropdownOptions.height;
    } else {
      /// set dropdown height not to overflow screen
      if (resultOffset.dy + resultBox.size.height + dropdownOptions.height >
          screenHeight) {
        _calcDropdownHeight =
            screenHeight - (resultOffset.dy + resultBox.size.height);
      }
      return resultOffset.dy + resultBox.size.height;
    }
  }

  double get calcArrowAlignmentDx {
    switch (dropdownArrowOptions.arrowAlign) {
      case DropdownArrowAlign.left:
        if (_isArrowDown) {
          return _arrowLeftCenterDx(dropdownOptions.borderRadius.topLeft.x);
        } else {
          return _arrowLeftCenterDx(dropdownOptions.borderRadius.bottomLeft.x);
        }
      case DropdownArrowAlign.right:
        if (_isArrowDown) {
          return _arrowRightCenterDx(dropdownOptions.borderRadius.topRight.x);
        } else {
          return _arrowRightCenterDx(
              dropdownOptions.borderRadius.bottomRight.x);
        }
      case DropdownArrowAlign.center:
        return 0;
    }
  }

  double _arrowLeftCenterDx(double radius) {
    return ((radius + dropdownArrowOptions.width * 0.5) /
            dropdownOptions.width) -
        1;
  }

  double _arrowRightCenterDx(double radius) {
    return (dropdownOptions.width - radius - dropdownArrowOptions.width * 0.5) /
        dropdownOptions.width;
  }

  void setScrollPosition(int currentIndex) {
    final totalHeight = (dropdownItemOptions.height * dropdownList.length) +
        (dropdownOptions.gap.betweenItems * (dropdownList.length - 1));
    var scrollPosition = (dropdownItemOptions.height * currentIndex) +
        (dropdownOptions.gap.betweenItems * currentIndex);
    final overScrollPosition = scrollController.position.maxScrollExtent;
    if (overScrollPosition < scrollPosition) {
      scrollPosition = overScrollPosition;
    }
    if (totalHeight < dropdownOptions.height) {
      scrollPosition = 0;
    }
    scrollController.animateTo(scrollPosition,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}