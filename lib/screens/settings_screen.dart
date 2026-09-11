import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
import '../core/state/demo_controller.dart';
import '../core/state/sipsva_scope.dart';
import '../core/theme/app_colors.dart';
import '../widgets/responsive_content.dart';
import '../widgets/section_header.dart';
import '../widgets/surface_card.dart';
 
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
 
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
 
class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController? _phoneController;
  TextEditingController? _deviceController;
  DemoController? _source;
 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final source = SipsvaScope.of(context);
    if (_source == source) return;
    _source = source;
    _phoneController?.dispose();
    _deviceController?.dispose();
    _phoneController = TextEditingController(text: source.emergencyPhone);
    _deviceController = TextEditingController(text: source.deviceName);
  }
 
  @override
  void dispose() {
    _phoneController?.dispose();
    _deviceController?.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final controller = SipsvaScope.of(context);
 
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: ResponsiveContent(
                maxWidth: 860,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SectionHeader(
                      title: 'Configuración del prototipo',
                      subtitle:
                          'Ajustes locales; no se transmiten a ningún dispositivo',
                    ),
                    const SizedBox(height: 18),
                    SurfaceCard(
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9+ ()-]'),
                              ),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Número telefónico de emergencia',
                              prefixIcon: Icon(Icons.call_rounded),
                              helperText:
                                  'Uso demostrativo; no se realizan llamadas',
                            ),
                            onChanged: controller.setEmergencyPhone,
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _deviceController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del dispositivo ESP32',
                              prefixIcon: Icon(Icons.memory_rounded),
                            ),
                            onChanged: controller.setDeviceName,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SurfaceCard(
                      child: Column(
                        children: <Widget>[
                          _SliderSetting(
                            icon: Icons.speed_rounded,
                            title: 'Límite máximo de velocidad',
                            valueLabel:
                                '${controller.maximumSpeed.round()} km/h',
                            value: controller.maximumSpeed,
                            min: 30,
                            max: 130,
                            divisions: 20,
                            onChanged: controller.setMaximumSpeed,
                          ),
                          const Divider(height: 28),
                          _SliderSetting(
                            icon: Icons.brightness_6_rounded,
                            title: 'Brillo del panel',
                            valueLabel:
                                '${controller.panelBrightness.round()}%',
                            value: controller.panelBrightness,
                            min: 25,
                            max: 100,
                            divisions: 15,
                            onChanged: controller.setPanelBrightness,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SurfaceCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: <Widget>[
                          SwitchListTile(
                            value: controller.demoMode,
                            onChanged: controller.setDemoMode,
                            secondary: const Icon(
                              Icons.science_rounded,
                              color: AppColors.navy,
                            ),
                            title: const Text('Modo demostración'),
                            subtitle: const Text(
                              'Activa controles para modificar únicamente la UI',
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOutCubic,
                            child: controller.demoMode
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      18,
                                      0,
                                      18,
                                      18,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Divider(),
                                        Text(
                                          'Simular condiciones',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 12),
                                        Wrap(
                                          spacing: 9,
                                          runSpacing: 9,
                                          children: <Widget>[
                                            _DemoButton(
                                              active: controller.raining,
                                              icon: Icons.water_drop_rounded,
                                              label: 'Lluvia',
                                              onPressed: () => _simulate(
                                                context,
                                                controller.toggleRain,
                                                'Lluvia',
                                              ),
                                            ),
                                            _DemoButton(
                                              active: controller.isNight,
                                              icon: Icons.dark_mode_rounded,
                                              label: 'Noche',
                                              onPressed: () => _simulate(
                                                context,
                                                controller.toggleNight,
                                                'Noche',
                                              ),
                                            ),
                                            _DemoButton(
                                              active: controller.speeding,
                                              icon: Icons.speed_rounded,
                                              label: 'Exceso de velocidad',
                                              onPressed: () => _simulate(
                                                context,
                                                controller.toggleSpeeding,
                                                'Exceso de velocidad',
                                              ),
                                            ),
                                            _DemoButton(
                                              active: controller.congestion,
                                              icon: Icons.traffic_rounded,
                                              label: 'Congestión',
                                              onPressed: () => _simulate(
                                                context,
                                                controller.toggleCongestion,
                                                'Congestión',
                                              ),
                                            ),
                                            _DemoButton(
                                              active: controller.smokeDetected,
                                              icon: Icons
                                                  .local_fire_department_rounded,
                                              label: 'Humo',
                                              onPressed: () => _simulate(
                                                context,
                                                controller.toggleSmoke,
                                                'Humo',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SurfaceCard(
                      padding: EdgeInsets.zero,
                      child: ExpansionTile(
                        initiallyExpanded: !controller.demoMode,
                        leading: const Icon(
                          Icons.developer_board_rounded,
                          color: AppColors.navy,
                        ),
                        title: const Text('Conexión con la ESP32 real'),
                        subtitle: Text(
                          controller.demoMode
                              ? 'Desactiva el modo demostración para usar Bluetooth real'
                              : controller.espConnected
                              ? 'Conectada por Web Bluetooth'
                              : 'Sin conectar',
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          18,
                          0,
                          18,
                          18,
                        ),
                        children: <Widget>[
                          const Divider(),
                          const Text(
                            'Con el modo demostración desactivado, el botón '
                            'de abajo abre el selector de Bluetooth del '
                            'navegador para emparejar con la maqueta '
                            '(SIPSVA-ESP32). Requiere Chrome, Edge u Opera; '
                            'Safari y Firefox no son compatibles con Web '
                            'Bluetooth.',
                          ),
                          const SizedBox(height: 14),
                          if (!controller.canUseRealDevice)
                            const Text(
                              'Este navegador o plataforma no soporta Web Bluetooth.',
                              style: TextStyle(color: AppColors.dangerRed),
                            )
                          else if (controller.demoMode)
                            FilledButton.tonalIcon(
                              onPressed: () => controller.setDemoMode(false),
                              icon: const Icon(Icons.bluetooth_rounded),
                              label: const Text(
                                'Desactivar modo demostración',
                              ),
                            )
                          else if (controller.espConnected)
                            FilledButton.tonalIcon(
                              onPressed: controller.disconnectRealDevice,
                              icon: const Icon(
                                Icons.bluetooth_disabled_rounded,
                              ),
                              label: const Text('Desconectar ESP32 real'),
                            )
                          else
                            FilledButton.icon(
                              onPressed: controller.connectingRealDevice
                                  ? null
                                  : controller.connectRealDevice,
                              icon: controller.connectingRealDevice
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.bluetooth_searching_rounded,
                                    ),
                              label: Text(
                                controller.connectingRealDevice
                                    ? 'Buscando dispositivo...'
                                    : 'Conectar ESP32 real',
                              ),
                            ),
                          if (controller.realConnectionError !=
                              null) ...<Widget>[
                            const SizedBox(height: 10),
                            Text(
                              'Último error: ${controller.realConnectionError}',
                              style: const TextStyle(
                                color: AppColors.dangerRed,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
 
  void _simulate(BuildContext context, VoidCallback action, String label) {
    action();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label actualizado en la demostración.')),
    );
  }
}
 
class _SliderSetting extends StatelessWidget {
  const _SliderSetting({
    required this.icon,
    required this.title,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });
 
  final IconData icon;
  final String title;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(icon, color: AppColors.navy),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              valueLabel,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.navy),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max).toDouble(),
          min: min,
          max: max,
          divisions: divisions,
          label: valueLabel,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
 
class _DemoButton extends StatelessWidget {
  const _DemoButton({
    required this.active,
    required this.icon,
    required this.label,
    required this.onPressed,
  });
 
  final bool active;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
 
  @override
  Widget build(BuildContext context) {
    return active
        ? FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
          )
        : FilledButton.tonalIcon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
          );
  }
}
