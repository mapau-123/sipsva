import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'status_dot.dart';
import 'surface_card.dart';

class SensorStatusTile extends StatelessWidget {
  const SensorStatusTile({
    required this.name,
    required this.value,
    required this.icon,
    required this.ok,
    this.detail,
    this.progress,
    super.key,
  });

  final String name;
  final String value;
  final IconData icon;
  final bool ok;
  final String? detail;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final color = ok ? AppColors.safeGreen : AppColors.dangerRed;

    return SurfaceCard(
      child: Row(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: color, size: 27),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    StatusDot(
                      active: ok,
                      semanticLabel: '$name: ${ok ? 'normal' : 'alerta'}',
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    value,
                    key: ValueKey<String>(value),
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: color),
                  ),
                ),
                if (detail != null)
                  Text(detail!, style: Theme.of(context).textTheme.bodyMedium),
                if (progress != null) ...<Widget>[
                  const SizedBox(height: 9),
                  LinearProgressIndicator(
                    value: progress!.clamp(0, 1).toDouble(),
                    color: color,
                    backgroundColor: AppColors.divider,
                    borderRadius: BorderRadius.circular(99),
                    minHeight: 5,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
