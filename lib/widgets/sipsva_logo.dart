import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class SipsvaLogo extends StatelessWidget {
  const SipsvaLogo({this.size = 48, this.heroTag, super.key});

  final double size;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final mark = Semantics(
      label: 'Logo de SIPSVA',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[AppColors.blue, AppColors.navy],
          ),
          borderRadius: BorderRadius.circular(size * 0.28),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.22),
              blurRadius: size * 0.25,
              offset: Offset(0, size * 0.09),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(Icons.route_rounded, color: Colors.white, size: size * 0.58),
            Positioned(
              right: size * 0.14,
              top: size * 0.13,
              child: Container(
                width: size * 0.16,
                height: size * 0.16,
                decoration: const BoxDecoration(
                  color: AppColors.signalYellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (heroTag == null) return mark;
    return Hero(tag: heroTag!, child: mark);
  }
}
