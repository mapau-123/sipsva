import 'package:flutter/material.dart';

import '../core/state/sipsva_scope.dart';
import '../core/theme/app_colors.dart';
import '../utils/status_visuals.dart';
import '../widgets/connection_pill.dart';
import '../widgets/metric_card.dart';
import '../widgets/responsive_content.dart';
import '../widgets/risk_indicator.dart';
import '../widgets/section_header.dart';
import '../widgets/surface_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SipsvaScope.of(context);
    final speedOk = controller.currentSpeed <= controller.maximumSpeed;
    final road = controller.roadCondition;

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: ResponsiveContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Carretera inteligente',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Resumen preventivo en tiempo real',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    ConnectionPill(connected: controller.espConnected),
                  ],
                ),
                const SizedBox(height: 22),
                RiskIndicator(level: controller.riskLevel),
                const SizedBox(height: 28),
                const SectionHeader(
                  title: 'Condiciones actuales',
                  subtitle: 'Lecturas simuladas de la zona monitoreada',
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 850 ? 4 : 2;
                    const spacing = 12.0;
                    final width =
                        (constraints.maxWidth - (columns - 1) * spacing) /
                        columns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: <Widget>[
                        SizedBox(
                          width: width,
                          height: 174,
                          child: MetricCard(
                            title: 'Velocidad',
                            value: '${controller.currentSpeed.round()} km/h',
                            subtitle: speedOk
                                ? 'Dentro del límite'
                                : 'Límite superado',
                            icon: Icons.speed_rounded,
                            color: speedOk
                                ? AppColors.safeGreen
                                : AppColors.dangerRed,
                            progress: controller.currentSpeed / 140,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          height: 174,
                          child: MetricCard(
                            title: 'Clima',
                            value: controller.raining
                                ? 'Lluvia ${controller.rainPercentage.round()}%'
                                : 'Sin lluvia',
                            subtitle: controller.raining
                                ? 'Calzada húmeda'
                                : 'Condición estable',
                            icon: controller.raining
                                ? Icons.water_drop_rounded
                                : Icons.cloud_outlined,
                            color: controller.raining
                                ? AppColors.blue
                                : AppColors.safeGreen,
                            progress: controller.rainPercentage / 100,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          height: 174,
                          child: MetricCard(
                            title: 'Iluminación',
                            value: controller.isNight ? 'Noche' : 'Día',
                            subtitle: controller.isNight
                                ? 'Luces recomendadas'
                                : 'Visibilidad favorable',
                            icon: controller.isNight
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: controller.isNight
                                ? Colors.indigo
                                : AppColors.signalYellow,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          height: 174,
                          child: MetricCard(
                            title: 'Estado de la vía',
                            value: road.label,
                            subtitle: 'Evaluación ultrasónica y MQ-2',
                            icon: road.icon,
                            color: road.color,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 22),
                SurfaceCard(
                  padding: EdgeInsets.zero,
                  child: ExpansionTile(
                    leading: const Icon(
                      Icons.analytics_outlined,
                      color: AppColors.navy,
                    ),
                    title: const Text('Resumen de evaluación preventiva'),
                    subtitle: Text(
                      'Mensaje activo: ${controller.panelMessage}',
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    children: <Widget>[
                      const Divider(),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: _SummaryItem(
                              label: 'Dispositivo',
                              value: controller.deviceName,
                            ),
                          ),
                          Expanded(
                            child: _SummaryItem(
                              label: 'Límite vial',
                              value: '${controller.maximumSpeed.round()} km/h',
                            ),
                          ),
                          Expanded(
                            child: _SummaryItem(
                              label: 'Panel',
                              value: '${controller.panelBrightness.round()}%',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: <Widget>[
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
