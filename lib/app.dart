import 'package:flutter/material.dart';

import 'core/state/demo_controller.dart';
import 'core/state/sipsva_scope.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/web_ble_esp32_service.dart';

class SipsvaBootstrap extends StatefulWidget {
  const SipsvaBootstrap({super.key});

  @override
  State<SipsvaBootstrap> createState() => _SipsvaBootstrapState();
}

class _SipsvaBootstrapState extends State<SipsvaBootstrap> {
  late final DemoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DemoController(esp32Service: WebBleEsp32Service());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SipsvaScope(
      notifier: _controller,
      child: MaterialApp(
        title: 'SIPSVA',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}
