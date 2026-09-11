import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class LedPanel extends StatelessWidget {
  const LedPanel({required this.message, this.brightness = 1, super.key});

  final String message;
  final double brightness;

  @override
  Widget build(BuildContext context) {
    final intensity = brightness.clamp(0.25, 1.0).toDouble();

    return Semantics(
      label: 'Panel vial electrónico: $message',
      liveRegion: true,
      child: RepaintBoundary(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.panelBlack,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF252525), width: 3),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black45,
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: CustomPaint(
            painter: const _LedGridPainter(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 36),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 380),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: Text(
                    message,
                    key: ValueKey<String>(message),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.signalYellow.withValues(
                        alpha: intensity,
                      ),
                      fontSize: 38,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3.4,
                      shadows: <Shadow>[
                        Shadow(
                          color: AppColors.signalYellow.withValues(
                            alpha: intensity * 0.8,
                          ),
                          blurRadius: 12,
                        ),
                        Shadow(
                          color: AppColors.signalYellow.withValues(
                            alpha: intensity * 0.35,
                          ),
                          blurRadius: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LedGridPainter extends CustomPainter {
  const _LedGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..style = PaintingStyle.fill;

    const spacing = 13.0;
    for (var x = 7.0; x < size.width; x += spacing) {
      for (var y = 7.0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.15, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
