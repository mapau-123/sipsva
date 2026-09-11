import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'status_dot.dart';

class ConnectionPill extends StatelessWidget {
  const ConnectionPill({
    required this.connected,
    this.compact = false,
    super.key,
  });

  final bool connected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: connected ? 'ESP32 conectada' : 'ESP32 desconectada',
      container: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 13,
          vertical: compact ? 7 : 9,
        ),
        decoration: BoxDecoration(
          color: (connected ? AppColors.safeGreen : AppColors.dangerRed)
              .withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: (connected ? AppColors.safeGreen : AppColors.dangerRed)
                .withValues(alpha: 0.22),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StatusDot(active: connected, size: compact ? 8 : 10),
            const SizedBox(width: 8),
            Text(
              compact
                  ? (connected ? 'Conectada' : 'Sin conexión')
                  : (connected ? 'ESP32 conectada' : 'ESP32 desconectada'),
              style: TextStyle(
                color: connected
                    ? const Color(0xFF267B2B)
                    : AppColors.dangerRed,
                fontWeight: FontWeight.w800,
                fontSize: compact ? 11 : 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
