import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';

class DropdownController implements TickerProvider {
  late final AnimationController controller;

  OverlayEntry? overlayEntry;

  DropdownController._() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  static Map _instances = {};

  static DropdownController getInstance(String key) {
    if (!_instances.containsKey(key)) {
      _instances[key] = createInstance();
    }
    return _instances[key]!;
  }

  static DropdownController createInstance() {
    return DropdownController._();
  }

  Animation<double> get rotation => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      );

  Animation<double> get opacity => Tween<double>(begin: .0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
        ),
      );

  void open({required BuildContext context, required Widget child}) {
    overlayEntry = OverlayEntry(builder: (_) => child);
    if (overlayEntry == null) return;
    Overlay.of(context).insert(overlayEntry!);
    controller.forward();
  }

  void close() async {
    await controller.reverse();
    overlayEntry?.remove();
  }

  void dispose() {
    controller.dispose();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick, debugLabel: 'DropdownController');
  }
}
