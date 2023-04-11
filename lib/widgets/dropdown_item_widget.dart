import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:flutter/material.dart';

class DropdownItemWidget extends StatefulWidget {
  final CoolDropdownItem item;
  final DropdownItemOptions dropdownItemOptions;

  const DropdownItemWidget({
    Key? key,
    required this.item,
    required this.dropdownItemOptions,
  }) : super(key: key);

  @override
  State<DropdownItemWidget> createState() => _DropdownItemWidgetState();
}

class _DropdownItemWidgetState extends State<DropdownItemWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final _decorationBoxTween = DecorationTween(
    begin: BoxDecoration(),
    end: widget.dropdownItemOptions.selectedBoxDecoration,
  ).animate(_controller);

  late final _textStyleTween = TextStyleTween(
    begin: widget.dropdownItemOptions.textStyle,
    end: widget.dropdownItemOptions.selectedTextStyle,
  ).animate(_controller);

  @override
  void didUpdateWidget(covariant DropdownItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.item.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBoxTransition(
      decoration: _decorationBoxTween,
      child: Container(
        padding: widget.dropdownItemOptions.selectedPadding,
        height: widget.dropdownItemOptions.height,
        alignment: widget.dropdownItemOptions.alignment,
        child: DefaultTextStyleTransition(
          child: Text(widget.item.label),
          style: _textStyleTween,
        ),
      ),
    );
  }
}
