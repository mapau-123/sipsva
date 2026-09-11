import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/state/demo_controller.dart';
import '../core/state/sipsva_scope.dart';
import '../core/theme/app_colors.dart';
import '../widgets/connection_pill.dart';
import '../widgets/sipsva_logo.dart';
import 'about_screen.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'incidents_screen.dart';
import 'intelligent_panel_screen.dart';
import 'monitoring_screen.dart';
import 'settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  var _selectedIndex = 0;

  Future<void> _handleConnectionTap(
    BuildContext context,
    DemoController controller,
  ) async {
    if (controller.demoMode) {
      controller.toggleConnection();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.espConnected
                ? 'ESP32 conectada en modo demostración.'
                : 'ESP32 desconectada en modo demostración.',
          ),
        ),
      );
      return;
    }

    if (controller.espConnected) {
      await controller.disconnectRealDevice();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ESP32 real desconectada.')),
        );
      }
      return;
    }

    await controller.connectRealDevice();
    if (!context.mounted) return;
    final error = controller.realConnectionError;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error != null
              ? 'No se pudo conectar: $error'
              : 'ESP32 real conectada por Bluetooth.',
        ),
      ),
    );
  }

  static const _titles = <String>[
    'Centro de monitoreo',
    'Panel inteligente',
    'Monitoreo de sensores',
    'Historial de eventos',
    'Emergencias',
    'Configuración',
    'Acerca de SIPSVA',
  ];

  static const _screens = <Widget>[
    DashboardScreen(),
    IntelligentPanelScreen(),
    MonitoringScreen(),
    HistoryScreen(),
    IncidentsScreen(),
    SettingsScreen(),
    AboutScreen(),
  ];

  static const _destinations = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard_rounded),
      label: 'Inicio',
    ),
    NavigationDestination(
      icon: Icon(Icons.signpost_outlined),
      selectedIcon: Icon(Icons.signpost_rounded),
      label: 'Panel',
    ),
    NavigationDestination(
      icon: Icon(Icons.sensors_outlined),
      selectedIcon: Icon(Icons.sensors_rounded),
      label: 'Monitoreo',
    ),
    NavigationDestination(
      icon: Icon(Icons.timeline_outlined),
      selectedIcon: Icon(Icons.timeline_rounded),
      label: 'Historial',
    ),
    NavigationDestination(
      icon: Icon(Icons.emergency_outlined),
      selectedIcon: Icon(Icons.emergency_rounded),
      label: 'Emergencias',
    ),
    NavigationDestination(
      icon: Icon(Icons.tune_outlined),
      selectedIcon: Icon(Icons.tune_rounded),
      label: 'Configuración',
    ),
    NavigationDestination(
      icon: Icon(Icons.info_outline_rounded),
      selectedIcon: Icon(Icons.info_rounded),
      label: 'Acerca de',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = SipsvaScope.of(context);
    final panelMode = _selectedIndex == 1;

    return Scaffold(
      backgroundColor: panelMode ? AppColors.panelBlack : null,
      appBar: AppBar(
        backgroundColor: panelMode ? AppColors.panelBlack : AppColors.surface,
        foregroundColor: panelMode ? Colors.white : AppColors.ink,
        titleSpacing: 16,
        title: Row(
          children: <Widget>[
            Badge(
              isLabelVisible: !controller.espConnected,
              label: const Text('!'),
              backgroundColor: AppColors.dangerRed,
              child: const SipsvaLogo(size: 38, heroTag: 'sipsva-logo'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'SIPSVA',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: panelMode ? Colors.white : AppColors.navy,
                    ),
                  ),
                  Text(
                    _titles[_selectedIndex],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: panelMode ? Colors.white60 : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: ConnectionPill(
                connected: controller.espConnected,
                compact: true,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: controller.connectingRealDevice
                  ? null
                  : () => _handleConnectionTap(context, controller),
              icon: controller.connectingRealDevice
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      controller.espConnected
                          ? Icons.link_off_rounded
                          : Icons.link_rounded,
                    ),
              label: Text(
                controller.connectingRealDevice
                    ? 'Conectando…'
                    : controller.espConnected
                    ? 'Desconectar'
                    : controller.demoMode
                    ? 'Conectar'
                    : 'Conectar ESP32 real',
              ),
            )
          : null,
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final width = math.max(constraints.maxWidth, 7 * 82.0);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: width,
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: _destinations,
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
