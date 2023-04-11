import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';

class DropdownController implements TickerProvider {
  late final AnimationController _controller;
  final Duration duration;
  final Animation<double>? resultIconAnimation;
  final Animation<double>? showDropdownAnimation;

  OverlayEntry? _overlayEntry;

  DropdownController({
    this.duration = const Duration(milliseconds: 500),
    this.resultIconAnimation,
    this.showDropdownAnimation,
  }) {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
  }

  AnimationController get controller => _controller;

  Animation<double> get rotation =>
      resultIconAnimation ??
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      );

  Animation<double> get showDropdown =>
      showDropdownAnimation ??
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
        ),
      );

  void open({required BuildContext context, required Widget child}) {
    _overlayEntry = OverlayEntry(builder: (_) => child);
    if (_overlayEntry == null) return;
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  void close() async {
    await _controller.reverse();
    _overlayEntry?.remove();
  }

  void dispose() {
    _controller.dispose();
  }

  void _setOffset({
    required GlobalKey key,
  }) {
    final _resultBox = key.currentContext?.findRenderObject() as RenderBox;
    final _resultOffset = _resultBox.localToGlobal(Offset.zero);
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick, debugLabel: 'DropdownController');
  }
}
