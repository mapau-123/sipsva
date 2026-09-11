import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../widgets/responsive_content.dart';
import '../widgets/sipsva_logo.dart';
import '../widgets/surface_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: ResponsiveContent(
            maxWidth: 820,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 12),
                const SipsvaLogo(size: 96),
                const SizedBox(height: 20),
                Text(
                  'SIPSVA',
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(color: AppColors.navy),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sistema Inteligente Preventivo de Señalización Vial '
                  'Adaptativa',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Chip(
                  avatar: Icon(Icons.science_rounded, size: 18),
                  label: Text('Proyecto de investigación · Versión 1.0.0'),
                ),
                const SizedBox(height: 24),
                const _AboutCard(
                  icon: Icons.flag_rounded,
                  title: 'Objetivo',
                  text:
                      'Prevenir accidentes de tránsito mediante una carretera '
                      'inteligente capaz de evaluar condiciones de riesgo y '
                      'emitir advertencias oportunas.',
                ),
                const SizedBox(height: 12),
                const _AboutCard(
                  icon: Icons.route_rounded,
                  title: 'Descripción',
                  text:
                      'El prototipo integra sensores conectados a una ESP32, '
                      'un panel electrónico de señalización y esta aplicación '
                      'de monitoreo. La interfaz actual emplea datos simulados.',
                ),
                const SizedBox(height: 12),
                SurfaceCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: const <Widget>[
                      ExpansionTile(
                        leading: Icon(
                          Icons.school_rounded,
                          color: AppColors.navy,
                        ),
                        title: Text('Institución educativa'),
                        subtitle: Text('Información editable del proyecto'),
                        childrenPadding: EdgeInsets.fromLTRB(18, 0, 18, 18),
                        children: <Widget>[
                          Divider(),
                          Text(
                            'Nombre de la institución educativa\n'
                            'Programa, curso o semillero de investigación',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Divider(height: 1),
                      ExpansionTile(
                        leading: Icon(
                          Icons.groups_rounded,
                          color: AppColors.navy,
                        ),
                        title: Text('Equipo desarrollador'),
                        subtitle: Text('Integrantes y asesoría'),
                        childrenPadding: EdgeInsets.fromLTRB(18, 0, 18, 18),
                        children: <Widget>[
                          Divider(),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: <Widget>[
                              Chip(label: Text('Integrante 1')),
                              Chip(label: Text('Integrante 2')),
                              Chip(label: Text('Integrante 3')),
                              Chip(label: Text('Docente asesor')),
                            ],
                          ),
                        ],
                      ),
                      Divider(height: 1),
                      ExpansionTile(
                        leading: Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.navy,
                        ),
                        title: Text('Información técnica'),
                        subtitle: Text('Alcance de esta versión'),
                        childrenPadding: EdgeInsets.fromLTRB(18, 0, 18, 18),
                        children: <Widget>[
                          Divider(),
                          Text(
                            'Prototipo UI para Android desarrollado en Flutter '
                            'con Material Design 3. No incluye backend, base de '
                            'datos, Wi-Fi ni lógica real de sensores.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  'Tecnología para una movilidad más segura',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.blue,
                    letterSpacing: 0.6,
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

class _AboutCard extends StatelessWidget {
  const _AboutCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.navy),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(text, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
