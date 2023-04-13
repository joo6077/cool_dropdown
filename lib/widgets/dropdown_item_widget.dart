import 'package:cool_dropdown/enums/dropdown_item_render.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cool_dropdown/options/dropdown_item_options.dart';
import 'package:cool_dropdown/utils/extension_util.dart';
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

  late final _paddingTween = EdgeInsetsTween(
    begin: widget.dropdownItemOptions.padding,
    end: widget.dropdownItemOptions.selectedPadding,
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

  List<Widget> _buildDropdownItem() {
    return [
      /// if you want to show icon in result widget
      if (widget.dropdownItemOptions.render == DropdownItemRender.all ||
          widget.dropdownItemOptions.render == DropdownItemRender.label ||
          widget.dropdownItemOptions.render == DropdownItemRender.reverse)
        Text(
          widget.item.label,
          style: _textStyleTween.value,
        ),

      /// if you want to show icon in result widget
      if (widget.dropdownItemOptions.render == DropdownItemRender.all ||
          widget.dropdownItemOptions.render == DropdownItemRender.icon ||
          widget.dropdownItemOptions.render == DropdownItemRender.reverse)
        _buildIcon(),
    ].isReverse(
        widget.dropdownItemOptions.render == DropdownItemRender.reverse);
  }

  Widget _buildIcon() {
    if (widget.item.icon == null && widget.item.selectedIcon == null) {
      return const SizedBox();
    } else if (widget.item.icon == null) {
      return widget.item.selectedIcon!;
    } else if (widget.item.selectedIcon == null) {
      return widget.item.icon!;
    } else {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return FadeTransition(child: child, opacity: animation);
        },
        child: Container(
          key: ValueKey(widget.item.isSelected),
          child: widget.item.isSelected
              ? widget.item.selectedIcon
              : widget.item.icon,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Container(
            padding: _paddingTween.value,
            height: widget.dropdownItemOptions.height,
            alignment: widget.dropdownItemOptions.alignment,
            decoration: _decorationBoxTween.value,
            child: Align(
              alignment: widget.dropdownItemOptions.alignment,
              child: Row(
                mainAxisAlignment: widget.dropdownItemOptions.mainAxisAlignment,
                children: _buildDropdownItem(),
              ),
            ),
          );
        });
  }
}
