import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';

class DropdownController implements TickerProvider {
  late final AnimationController _controller;
  late final AnimationController _errorController;
  final Duration duration;
  final Animation<double>? resultArrowAnimation;
  final Animation<double>? resultBoxAnimation;
  final Animation<double>? showDropdownAnimation;

  OverlayEntry? _overlayEntry;

  ValueNotifier<bool> _isOpenNotifier = ValueNotifier(false);
  ValueNotifier<bool> get isOpenNotifier => _isOpenNotifier;

  ValueNotifier<bool> _isErrorNotifier = ValueNotifier(false);
  ValueNotifier<bool> get isErrorNotifier => _isErrorNotifier;

  DropdownController({
    this.duration = const Duration(milliseconds: 500),
    this.resultArrowAnimation,
    this.resultBoxAnimation,
    this.showDropdownAnimation,
  }) {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    _errorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  AnimationController get controller => _controller;
  AnimationController get errorController => _errorController;

  Tween<Decoration> errorDecorationTween = Tween<Decoration>(
    begin: BoxDecoration(
      color: Colors.transparent,
    ),
    end: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(10),
    ),
  );

  Animation<Decoration> get errorDecoration =>
      errorDecorationTween.animate(_errorController);

  Animation<double> get rotation =>
      resultArrowAnimation ??
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      );

  Animation<double> get resultBox =>
      resultBoxAnimation ??
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

  Animation<double> get showError => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _errorController,
          curve: Curves.easeIn,
        ),
      );

  void open({required BuildContext context, required Widget child}) {
    _overlayEntry = OverlayEntry(builder: (_) => child);
    if (_overlayEntry == null) return;
    Overlay.of(context).insert(_overlayEntry!);

    _isOpenNotifier.value = true;

    _controller.forward();
  }

  void close() async {
    await _controller.reverse();
    _overlayEntry?.remove();

    _isOpenNotifier.value = false;
  }

  void error() {
    _isErrorNotifier.value = true;
    _errorController.reset();
    _errorController.forward();
  }

  void resetError() {
    _isErrorNotifier.value = false;
  }

  void _setErrorDecorationBox(Decoration startDecoration) {
    errorDecorationTween.begin = startDecoration;
  }

  void setResultBoxDecoration(
      Decoration startDecoration, Decoration endDecoration) {}

  void dispose() {
    _controller.dispose();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick, debugLabel: 'DropdownController');
  }
}
