import 'package:flutter/material.dart';

import '../core/state/sipsva_scope.dart';
import '../core/theme/app_colors.dart';
import '../widgets/led_panel.dart';

class IntelligentPanelScreen extends StatelessWidget {
  const IntelligentPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SipsvaScope.of(context);

    return ColoredBox(
      color: AppColors.panelBlack,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.circle, size: 9, color: AppColors.safeGreen),
                  const SizedBox(width: 8),
                  Text(
                    'PANEL VIAL · MENSAJE AUTOMÁTICO',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white60,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${controller.panelBrightness.round()}%',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.brightness_6_rounded,
                    color: Colors.white54,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: LedPanel(
                  message: controller.panelMessage,
                  brightness: controller.panelBrightness / 100,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'La advertencia responde al estado combinado de los sensores.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
