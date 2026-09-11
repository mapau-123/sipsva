import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color = AppColors.surface,
    this.onTap,
    this.borderColor,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final VoidCallback? onTap;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: borderColor ?? AppColors.divider),
      ),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.055),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
