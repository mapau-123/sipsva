import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class StatusDot extends StatelessWidget {
  const StatusDot({
    required this.active,
    this.size = 11,
    this.semanticLabel,
    super.key,
  });

  final bool active;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.safeGreen : AppColors.dangerRed;
    return Semantics(
      label: semanticLabel ?? (active ? 'Estado activo' : 'Estado inactivo'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withValues(alpha: 0.45),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
