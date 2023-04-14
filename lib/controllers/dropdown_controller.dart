import 'package:cool_dropdown/options/result_options.dart';
import 'package:cool_dropdown/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';

class DropdownController implements TickerProvider {
  late final AnimationController _controller;
  late final AnimationController _errorController;
  final Duration duration;
  final Duration errorDuration;
  final Animation<double>? resultArrowAnimation;
  final Animation<double>? resultBoxAnimation;
  final Animation<double>? showDropdownAnimation;
  final Animation<double>? showErrorAnimation;

  OverlayEntry? _overlayEntry;

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  Function? onError;
  Function(bool)? onOpen;

  bool _isError = false;
  bool get isError => _isError;

  ResultOptions _resultOptions = ResultOptions();

  DropdownController({
    this.duration = const Duration(milliseconds: 500),
    this.errorDuration = const Duration(milliseconds: 500),
    this.resultArrowAnimation,
    this.resultBoxAnimation,
    this.showDropdownAnimation,
    this.showErrorAnimation,
  }) {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    _errorController = AnimationController(
      vsync: this,
      duration: errorDuration,
    );
  }

  AnimationController get controller => _controller;
  AnimationController get errorController => _errorController;

  Tween<Decoration> errorDecorationTween = DecorationTween(
    begin: BoxDecoration(),
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

  void open({required BuildContext context, required DropdownWidget child}) {
    _overlayEntry = OverlayEntry(builder: (_) => child);
    if (_overlayEntry == null) return;
    Overlay.of(context).insert(_overlayEntry!);

    _isOpen = true;
    onOpen?.call(true);

    _controller.forward();
  }

  void close() async {
    await _controller.reverse();
    _overlayEntry?.remove();

    _isOpen = false;
    onOpen?.call(false);
  }

  void error() {
    if (_isError) return;
    _setErrorDecorationTween(
        _resultOptions.boxDecoration, _resultOptions.errorBoxDecoration);
    onError?.call(true);
    _isError = true;
    _errorController.reset();
    _errorController.forward();
  }

  Future<void> resetError() async {
    _setErrorDecorationTween(
        errorDecorationTween.end!,
        _isOpen
            ? _resultOptions.openBoxDecoration
            : _resultOptions.boxDecoration);
    _errorController.reset();
    await _errorController.forward();
    onError?.call(false);
    _isError = false;
  }

  void setFunctions(Function errorFunction, Function(bool)? openFunction) {
    onError = errorFunction;
    onOpen = openFunction;
  }

  void setResultOptions(ResultOptions resultOptions) {
    _resultOptions = resultOptions;
  }

  void _setErrorDecorationTween(Decoration begin, Decoration end) {
    errorDecorationTween.begin = begin;
    errorDecorationTween.end = end;
  }

  void dispose() {
    _controller.dispose();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick, debugLabel: 'DropdownController');
  }
}
