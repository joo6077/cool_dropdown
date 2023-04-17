import 'package:cool_dropdown/controllers/dropdown_calculator.dart';
import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/customPaints/dropdown_shape_border.dart';
import 'package:cool_dropdown/enums/dropdown_animation.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_triangle_options.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/options/dropdown_options.dart';
import 'package:cool_dropdown/typedefs/typedef.dart';
import 'package:cool_dropdown/widgets/dropdown_item_widget.dart';
import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatefulWidget {
  final DropdownOptions dropdownOptions;
  final DropdownItemOptions dropdownItemOptions;
  final DropdownTriangleOptions dropdownTriangleOptions;
  final DropdownController controller;

  final GlobalKey resultKey;
  final BuildContext bodyContext;

  final List<CoolDropdownItem> dropdownList;

  final Function(T t) onChange;

  final GetSelectedItem getSelectedItem;
  final CoolDropdownItem<T>? selectedItem;

  const DropdownWidget({
    Key? key,
    required this.dropdownOptions,
    required this.dropdownItemOptions,
    required this.dropdownTriangleOptions,
    required this.controller,
    required this.resultKey,
    required this.bodyContext,
    required this.dropdownList,
    required this.onChange,
    required this.getSelectedItem,
    required this.selectedItem,
  }) : super(key: key);

  @override
  DropdownWidgetState<T> createState() => DropdownWidgetState<T>();
}

class DropdownWidgetState<T> extends State<DropdownWidget<T>> {
  var dropdownOffset = Offset(0, 0);
  late final DropdownCalculator _dropdownCalculator;

  @override
  void initState() {
    _dropdownCalculator = DropdownCalculator(
      bodyContext: widget.bodyContext,
      resultKey: widget.resultKey,
      dropdownOptions: widget.dropdownOptions,
      dropdownTriangleOptions: widget.dropdownTriangleOptions,
      dropdownItemOptions: widget.dropdownItemOptions,
      dropdownList: widget.dropdownList,
    );

    dropdownOffset = _dropdownCalculator.setOffset();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final currentIndex = widget.dropdownList
          .indexWhere((dropdownItem) => dropdownItem == widget.selectedItem);
      if (currentIndex < 0) return;
      _setSelectedItem(currentIndex);
      _dropdownCalculator.setScrollPosition(currentIndex);
    });
    super.initState();
  }

  @override
  void dispose() {
    _dropdownCalculator.dispose();
    super.dispose();
  }

  void _setSelectedItem(int index) {
    setState(() {
      for (var i = 0; i < widget.dropdownList.length; i++) {
        if (index == i) {
          widget.dropdownList[i] =
              widget.dropdownList[i].copyWith(isSelected: true);
          widget.getSelectedItem(i);
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
                  width: _dropdownCalculator.dropdownWidth,
                  height: _dropdownCalculator.dropdownHeight +
                      widget.dropdownOptions.borderSide.width,
                  padding: EdgeInsets.all(
                      widget.dropdownOptions.borderSide.width * 0.5),
                  decoration: ShapeDecoration(
                    color: widget.dropdownOptions.color,
                    shadows: widget.dropdownOptions.shadows,
                    shape: DropdownShapeBorder(
                      triangle: widget.dropdownTriangleOptions,
                      radius: widget.dropdownOptions.borderRadius,
                      borderSide: widget.dropdownOptions.borderSide,
                      arrowAlign: widget.dropdownTriangleOptions.align,
                      isTriangleDown: _dropdownCalculator.isArrowDown,
                    ),
                  ),
                  child: ListView.builder(
                    controller: _dropdownCalculator.scrollController,
                    padding: widget.dropdownOptions.calcPadding,
                    itemCount: widget.dropdownList.length,
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () {
                        widget.onChange.call(widget.dropdownList[index].value);
                        _setSelectedItem(index);
                      },
                      child: Column(
                        children: [
                          if (index == 0)
                            SizedBox(
                              height: widget.dropdownOptions.gap.top +
                                  widget.dropdownOptions.borderSide.width * 0.5,
                            ),
                          DropdownItemWidget(
                            item: widget.dropdownList[index],
                            dropdownItemOptions: widget.dropdownItemOptions,
                          ),
                          if (index != widget.dropdownList.length - 1)
                            SizedBox(
                              height: widget.dropdownOptions.gap.betweenItems,
                            ),
                          if (index == widget.dropdownList.length - 1)
                            SizedBox(
                              height: widget.dropdownOptions.gap.bottom +
                                  widget.dropdownOptions.borderSide.width * 0.5,
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
