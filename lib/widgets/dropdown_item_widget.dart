import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';

class DropdownItemWidget extends StatefulWidget {
  final CoolDropdownItem item;
  final TextStyle unselectedTS;
  final TextStyle selectedTS;
  final BoxDecoration selectedBD;
  final EdgeInsets padding;
  final Alignment alignment;

  const DropdownItemWidget({
    Key? key,
    required this.item,
    required this.unselectedTS,
    required this.selectedTS,
    required this.selectedBD,
    required this.padding,
    required this.alignment,
  }) : super(key: key);

  @override
  State<DropdownItemWidget> createState() => _DropdownItemWidgetState();
}

class _DropdownItemWidgetState extends State<DropdownItemWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final _decorationBoxTween = DecorationTween(
    begin: BoxDecoration(),
    end: widget.selectedBD,
  ).animate(_controller);

  late final _textStyleTween = TextStyleTween(
    begin: widget.unselectedTS,
    end: widget.selectedTS,
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
  Widget build(BuildContext context) {
    return DecoratedBoxTransition(
      decoration: _decorationBoxTween,
      child: Container(
        height: 50,
        alignment: widget.alignment,
        child: DefaultTextStyleTransition(
          child: Text(widget.item.label),
          style: _textStyleTween,
        ),
      ),
    );
  }
}
