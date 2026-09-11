import 'package:flutter/material.dart';

import '../core/state/sipsva_scope.dart';
import '../core/theme/app_colors.dart';
import '../models/timeline_event.dart';
import '../utils/status_visuals.dart';
import '../widgets/responsive_content.dart';
import '../widgets/section_header.dart';
import '../widgets/surface_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SipsvaScope.of(context);

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: ResponsiveContent(
            maxWidth: 820,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionHeader(
                  title: 'Línea de tiempo',
                  subtitle:
                      '${controller.events.length} eventos registrados en el prototipo',
                  trailing: IconButton.filledTonal(
                    tooltip: 'Filtrar eventos',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Los filtros estarán disponibles en la versión conectada.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.filter_list_rounded),
                  ),
                ),
                const SizedBox(height: 20),
                SurfaceCard(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.events.length,
                    itemBuilder: (context, index) {
                      final event = controller.events[index];
                      return _TimelineEntry(
                        event: event,
                        isFirst: index == 0,
                        isLast: index == controller.events.length - 1,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.event,
    required this.isFirst,
    required this.isLast,
  });

  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = event.type.color;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: 74,
            child: Padding(
              padding: const EdgeInsets.only(top: 23),
              child: Text(
                event.time,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.navy),
              ),
            ),
          ),
          SizedBox(
            width: 42,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : AppColors.divider,
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(event.type.icon, size: 18, color: color),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : AppColors.divider,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (event.detail != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      event.detail!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
