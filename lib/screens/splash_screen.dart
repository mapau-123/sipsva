import 'dart:async';

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../widgets/sipsva_logo.dart';
import 'home_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();

    _timer = Timer(const Duration(milliseconds: 2100), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeShell(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFEAF4FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.76, end: 1).animate(_fade),
                      child: const SipsvaLogo(
                        size: 108,
                        heroTag: 'sipsva-logo',
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'SIPSVA',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.navy,
                        fontSize: 42,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Text(
                        'Sistema Inteligente Preventivo de Señalización '
                        'Vial Adaptativa',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(height: 1.35),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'PROYECTO DE INVESTIGACIÓN',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.blue,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const SizedBox(
                      width: 34,
                      height: 34,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Inicializando centro de monitoreo…',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
