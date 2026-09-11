import 'package:flutter/material.dart';

import '../models/risk_level.dart';
import '../utils/status_visuals.dart';

class RiskIndicator extends StatelessWidget {
  const RiskIndicator({required this.level, super.key});

  final RiskLevel level;

  @override
  Widget build(BuildContext context) {
    final color = level.color;

    return Semantics(
      label: 'Nivel de riesgo: ${level.label}. ${level.description}',
      liveRegion: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              color.withValues(alpha: 0.16),
              color.withValues(alpha: 0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: color.withValues(alpha: 0.30)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withValues(alpha: 0.13),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(level.icon, color: Colors.white, size: 34),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'NIVEL DE RIESGO',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: color,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: Text(
                      level.label,
                      key: ValueKey<RiskLevel>(level),
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(color: color),
                    ),
                  ),
                  Text(level.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
