import 'package:flutter/widgets.dart';

import 'demo_controller.dart';

class SipsvaScope extends InheritedNotifier<DemoController> {
  const SipsvaScope({
    required DemoController notifier,
    required super.child,
    super.key,
  }) : super(notifier: notifier);

  static DemoController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SipsvaScope>();
    assert(scope != null, 'SipsvaScope no está disponible en este contexto.');
    return scope!.notifier!;
  }
}
