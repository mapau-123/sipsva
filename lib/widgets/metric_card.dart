import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'surface_card.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.progress,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: color.withValues(alpha: 0.35),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 22,
                color: AppColors.ink,
              ),
            ),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 3),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 12),
            ),
          ],
          if (progress != null) ...<Widget>[
            const SizedBox(height: 11),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: progress!.clamp(0, 1).toDouble(),
              ),
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                borderRadius: BorderRadius.circular(99),
                backgroundColor: AppColors.divider,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
