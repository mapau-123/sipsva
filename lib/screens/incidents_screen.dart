import 'package:flutter/material.dart';

import '../core/state/sipsva_scope.dart';
import '../core/theme/app_colors.dart';
import '../models/incident_type.dart';
import '../widgets/responsive_content.dart';
import '../widgets/section_header.dart';
import '../widgets/surface_card.dart';

class IncidentsScreen extends StatelessWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidents = IncidentType.values;

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: ResponsiveContent(
            maxWidth: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SectionHeader(
                  title: 'Reportar incidente',
                  subtitle:
                      'Seleccione el evento observado en el tramo monitoreado',
                ),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, constraints) {
                    const spacing = 14.0;
                    final width = (constraints.maxWidth - spacing) / 2;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: incidents
                          .map(
                            (incident) => SizedBox(
                              width: width,
                              height: 184,
                              child: _IncidentCard(
                                incident: incident,
                                onTap: () =>
                                    _showIncidentDialog(context, incident),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 18),
                SurfaceCard(
                  color: const Color(0xFFFFF8E1),
                  borderColor: AppColors.signalYellow,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF8A6500),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Esta pantalla es demostrativa. No realiza llamadas '
                          'ni contacta servicios de emergencia.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFF6A5200)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showIncidentDialog(
    BuildContext context,
    IncidentType incident,
  ) async {
    final controller = SipsvaScope.of(context);
    final call = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(_iconFor(incident), color: _colorFor(incident), size: 38),
          title: Text(incident.label),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                '¿Desea realizar una llamada de emergencia?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                'Número configurado: ${controller.emergencyPhone}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'En la implementación real podría comunicarse con el 123 '
                'o la entidad correspondiente.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.call_rounded),
              label: const Text('Llamar'),
            ),
          ],
        );
      },
    );

    if (call != true || !context.mounted) return;
    controller.registerIncident(incident.label);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Demostración: reporte de ${incident.label.toLowerCase()} registrado. '
          'No se realizó ninguna llamada.',
        ),
        action: SnackBarAction(label: 'Entendido', onPressed: () {}),
      ),
    );
  }
}

class _IncidentCard extends StatelessWidget {
  const _IncidentCard({required this.incident, required this.onTap});

  final IncidentType incident;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(incident);

    return SurfaceCard(
      onTap: onTap,
      borderColor: color.withValues(alpha: 0.22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(_iconFor(incident), color: color, size: 28),
          ),
          const Spacer(),
          Text(incident.label, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            incident.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

IconData _iconFor(IncidentType incident) => switch (incident) {
  IncidentType.accident => Icons.car_crash_rounded,
  IncidentType.brokenVehicle => Icons.car_repair_rounded,
  IncidentType.fire => Icons.local_fire_department_rounded,
  IncidentType.obstruction => Icons.report_problem_rounded,
};

Color _colorFor(IncidentType incident) => switch (incident) {
  IncidentType.accident => AppColors.dangerRed,
  IncidentType.brokenVehicle => AppColors.blue,
  IncidentType.fire => Colors.deepOrange,
  IncidentType.obstruction => AppColors.signalYellow,
};
