import 'package:flutter/material.dart';

import '../core/state/sipsva_scope.dart';
import '../core/theme/app_colors.dart';
import '../widgets/connection_pill.dart';
import '../widgets/responsive_content.dart';
import '../widgets/section_header.dart';
import '../widgets/sensor_status_tile.dart';
import '../widgets/surface_card.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SipsvaScope.of(context);
    final speedOk = controller.currentSpeed <= controller.maximumSpeed;

    final sensors = <Widget>[
      SensorStatusTile(
        name: 'ESP32',
        value: controller.espConnected ? 'Conectada' : 'Desconectada',
        detail: controller.deviceName,
        icon: Icons.memory_rounded,
        ok: controller.espConnected,
      ),
      SensorStatusTile(
        name: 'Sensor de lluvia',
        value: '${controller.rainPercentage.round()}%',
        detail: controller.raining ? 'Lluvia detectada' : 'Superficie seca',
        icon: Icons.water_drop_rounded,
        ok: !controller.raining,
        progress: controller.rainPercentage / 100,
      ),
      SensorStatusTile(
        name: 'Sensor de iluminación',
        value: controller.isNight ? 'Noche' : 'Día',
        detail: controller.isNight
            ? 'Visibilidad reducida'
            : 'Iluminación suficiente',
        icon: controller.isNight
            ? Icons.dark_mode_rounded
            : Icons.light_mode_rounded,
        ok: !controller.isNight,
      ),
      SensorStatusTile(
        name: 'Sensor de velocidad',
        value: '${controller.currentSpeed.round()} km/h',
        detail: 'Límite configurado: ${controller.maximumSpeed.round()} km/h',
        icon: Icons.speed_rounded,
        ok: speedOk,
        progress: controller.currentSpeed / 140,
      ),
      SensorStatusTile(
        name: 'Sensor ultrasónico',
        value: controller.congestion ? 'Congestión' : 'Vía libre',
        detail: controller.obstruction
            ? 'Obstrucción detectada'
            : 'Flujo evaluado en el tramo',
        icon: Icons.sensors_rounded,
        ok: !controller.congestion && !controller.obstruction,
      ),
      SensorStatusTile(
        name: 'Sensor MQ-2',
        value: controller.smokeDetected ? 'Humo detectado' : 'Sin humo',
        detail: 'Monitoreo de gases y combustión',
        icon: Icons.local_fire_department_rounded,
        ok: !controller.smokeDetected,
      ),
    ];

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: ResponsiveContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionHeader(
                  title: 'Telemetría del sistema',
                  subtitle: 'Estado visual de los módulos del prototipo',
                  trailing: ConnectionPill(connected: controller.espConnected),
                ),
                const SizedBox(height: 16),
                SurfaceCard(
                  color: AppColors.navy,
                  borderColor: AppColors.navy,
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.monitor_heart_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Monitoreo activo',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            Text(
                              'Datos de demostración actualizados en memoria',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sync_rounded,
                          color: AppColors.signalYellow,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 760;
                    if (!wide) {
                      return Column(
                        children: sensors
                            .map(
                              (sensor) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: sensor,
                              ),
                            )
                            .toList(),
                      );
                    }

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: sensors
                          .map(
                            (sensor) => SizedBox(
                              width: (constraints.maxWidth - 12) / 2,
                              child: sensor,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
