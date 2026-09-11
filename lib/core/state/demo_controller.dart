import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/risk_level.dart';
import '../../models/road_condition.dart';
import '../../models/timeline_event.dart';
import '../../services/esp32_service.dart';

class DemoController extends ChangeNotifier {
  DemoController({Esp32Service? esp32Service}) : _esp32Service = esp32Service;

  final Esp32Service? _esp32Service;
  StreamSubscription<Map<String, Object?>>? _telemetrySubscription;

  /// True mientras se intenta emparejar/conectar con la ESP32 real.
  bool connectingRealDevice = false;

  /// Último error de conexión o de lectura real (null si no hay ninguno).
  String? realConnectionError;

  /// Si hay un [Esp32Service] disponible para esta plataforma.
  bool get canUseRealDevice => _esp32Service != null;

  bool espConnected = true;
  bool demoMode = true;
  bool raining = true;
  bool isNight = false;
  bool speeding = false;
  bool congestion = false;
  bool obstruction = false;
  bool smokeDetected = false;

  double rainPercentage = 68;
  double currentSpeed = 72;
  double maximumSpeed = 80;
  double panelBrightness = 78;
  String emergencyPhone = '300 000 0000';
  String deviceName = 'SIPSVA-ESP32-01';

  final List<TimelineEvent> events = <TimelineEvent>[
    const TimelineEvent(
      time: '09:32',
      title: 'Reporte de incidente enviado',
      type: TimelineEventType.incident,
      detail: 'Simulación registrada por el operador.',
    ),
    const TimelineEvent(
      time: '09:30',
      title: 'Exceso de velocidad',
      type: TimelineEventType.speed,
      detail: 'Velocidad detectada: 92 km/h.',
    ),
    const TimelineEvent(
      time: '09:22',
      title: 'Congestión detectada',
      type: TimelineEventType.congestion,
      detail: 'Sensor ultrasónico reportó flujo detenido.',
    ),
    const TimelineEvent(
      time: '09:19',
      title: 'Panel cambió a “VÍA MOJADA”',
      type: TimelineEventType.panel,
    ),
    const TimelineEvent(
      time: '09:18',
      title: 'Lluvia detectada',
      type: TimelineEventType.rain,
      detail: 'Intensidad relativa: 68%.',
    ),
    const TimelineEvent(
      time: '09:15',
      title: 'Velocidad adecuada',
      type: TimelineEventType.success,
    ),
  ];

  RiskLevel get riskLevel {
    var score = 0;
    if (!espConnected) score += 1;
    if (raining) score += 1;
    if (isNight) score += 1;
    if (speeding) score += 2;
    if (congestion || obstruction) score += 2;
    if (smokeDetected) score += 3;

    if (score >= 4) return RiskLevel.high;
    if (score >= 1) return RiskLevel.medium;
    return RiskLevel.low;
  }

  RoadCondition get roadCondition {
    if (smokeDetected) return RoadCondition.smoke;
    if (obstruction) return RoadCondition.obstruction;
    if (congestion) return RoadCondition.congestion;
    return RoadCondition.normal;
  }

  String get panelMessage {
    if (smokeDetected) return 'HUMO DETECTADO';
    if (speeding) return 'REDUZCA VELOCIDAD';
    if (congestion) return 'CONGESTIÓN VEHICULAR';
    if (obstruction) return 'RIESGO ALTO';
    if (raining) return 'VÍA MOJADA';
    if (isNight) return 'ENCIENDA LUCES';
    return 'VELOCIDAD ADECUADA';
  }

  /// Alterna la conexión simulada. Solo tiene efecto en modo demostración;
  /// para la maqueta real usa [connectRealDevice]/[disconnectRealDevice].
  void toggleConnection() {
    espConnected = !espConnected;
    _addEvent(
      espConnected ? 'ESP32 conectada' : 'ESP32 desconectada',
      TimelineEventType.connection,
    );
    notifyListeners();
  }

  /// Abre el selector de Bluetooth del navegador y se conecta a la maqueta
  /// real. A partir de ahí, cada JSON recibido se traduce con
  /// [applyTelemetry].
  Future<void> connectRealDevice() async {
    final service = _esp32Service;
    if (service == null || connectingRealDevice) return;

    connectingRealDevice = true;
    realConnectionError = null;
    notifyListeners();

    try {
      await service.connect();
      demoMode = false;
      espConnected = true;
      _addEvent(
        'ESP32 real conectada por Bluetooth',
        TimelineEventType.connection,
      );

      await _telemetrySubscription?.cancel();
      _telemetrySubscription = service.telemetry.listen(
        applyTelemetry,
        onError: (Object error) {
          espConnected = false;
          realConnectionError = error.toString();
          notifyListeners();
        },
      );
    } catch (error) {
      espConnected = false;
      realConnectionError = error.toString();
    } finally {
      connectingRealDevice = false;
      notifyListeners();
    }
  }

  /// Cierra la conexión Bluetooth real, si hay una activa.
  Future<void> disconnectRealDevice() async {
    final service = _esp32Service;
    await _telemetrySubscription?.cancel();
    _telemetrySubscription = null;
    if (service != null) {
      await service.disconnect();
    }
    espConnected = false;
    _addEvent('ESP32 real desconectada', TimelineEventType.connection);
    notifyListeners();
  }

  /// Traduce el JSON que arma `crearJSON()` en el firmware Arduino
  /// (claves: rain, light, speed, smoke, lane1Occupied, lane2Occupied,
  /// trafficJam, ...) al estado que consume la interfaz.
  ///
  /// Nota: `isNight` se infiere del texto de `light` buscando palabras como
  /// "noche"/"oscur"/"baja". Si tu firmware usa otros textos para
  /// `estadoLuz`, dime cuáles son para ajustar esta detección con exactitud.
  void applyTelemetry(Map<String, Object?> data) {
    espConnected = true;
    realConnectionError = null;

    final newRain = (data['rain'] as num?)?.toDouble() ?? rainPercentage;
    final newRaining = newRain > 1;
    final newSpeed = (data['speed'] as num?)?.toDouble() ?? currentSpeed;
    final newSpeeding = newSpeed > maximumSpeed;
    final newSmoke = data['smoke'] == true;
    final lane1 = data['lane1Occupied'] == true;
    final lane2 = data['lane2Occupied'] == true;
    final newTrafficJam = data['trafficJam'] == true;
    final newObstruction = (lane1 || lane2) && !newTrafficJam;
    final lightState = (data['light']?.toString() ?? '').toUpperCase();
    final newIsNight = lightState == 'NIGHT';

    if (newRaining != raining) {
      _addEvent(
        newRaining ? 'Lluvia detectada' : 'Lluvia finalizada',
        TimelineEventType.rain,
      );
    }
    if (newIsNight != isNight) {
      _addEvent(
        newIsNight
            ? 'Modo nocturno detectado'
            : 'Iluminación diurna detectada',
        TimelineEventType.panel,
      );
    }
    if (newSpeeding != speeding) {
      _addEvent(
        newSpeeding ? 'Exceso de velocidad' : 'Velocidad adecuada',
        newSpeeding ? TimelineEventType.speed : TimelineEventType.success,
      );
    }
    if (newTrafficJam != congestion) {
      _addEvent(
        newTrafficJam ? 'Congestión detectada' : 'Vía nuevamente libre',
        TimelineEventType.congestion,
      );
    }
    if (newSmoke != smokeDetected) {
      _addEvent(
        newSmoke ? 'Humo detectado' : 'Nivel de humo normal',
        TimelineEventType.smoke,
      );
    }

    raining = newRaining;
    rainPercentage = newRain;
    isNight = newIsNight;
    speeding = newSpeeding;
    currentSpeed = newSpeed;
    obstruction = newObstruction;
    congestion = newTrafficJam;
    smokeDetected = newSmoke;

    notifyListeners();
  }

  void setDemoMode(bool value) {
    demoMode = value;
    notifyListeners();
  }

  void toggleRain() {
    raining = !raining;
    rainPercentage = raining ? 68 : 0;
    _addEvent(
      raining ? 'Lluvia detectada' : 'Lluvia finalizada',
      TimelineEventType.rain,
    );
    notifyListeners();
  }

  void toggleNight() {
    isNight = !isNight;
    _addEvent(
      isNight ? 'Modo nocturno detectado' : 'Iluminación diurna detectada',
      TimelineEventType.panel,
    );
    notifyListeners();
  }

  void toggleSpeeding() {
    speeding = !speeding;
    currentSpeed = speeding ? maximumSpeed + 18 : maximumSpeed - 8;
    _addEvent(
      speeding ? 'Exceso de velocidad' : 'Velocidad adecuada',
      speeding ? TimelineEventType.speed : TimelineEventType.success,
    );
    notifyListeners();
  }

  void toggleCongestion() {
    congestion = !congestion;
    _addEvent(
      congestion ? 'Congestión detectada' : 'Vía nuevamente libre',
      TimelineEventType.congestion,
    );
    notifyListeners();
  }

  void toggleSmoke() {
    smokeDetected = !smokeDetected;
    _addEvent(
      smokeDetected ? 'Humo detectado' : 'Nivel de humo normal',
      TimelineEventType.smoke,
    );
    notifyListeners();
  }

  void setMaximumSpeed(double value) {
    maximumSpeed = value;
    if (!speeding) currentSpeed = value - 8;
    notifyListeners();
  }

  void setPanelBrightness(double value) {
    panelBrightness = value;
    notifyListeners();
  }

  void setEmergencyPhone(String value) {
    emergencyPhone = value;
    notifyListeners();
  }

  void setDeviceName(String value) {
    deviceName = value;
    notifyListeners();
  }

  void registerIncident(String incidentName) {
    _addEvent(
      'Reporte: $incidentName',
      TimelineEventType.incident,
      detail: 'Evento demostrativo; no se realizó ninguna llamada.',
    );
    notifyListeners();
  }

  void _addEvent(String title, TimelineEventType type, {String? detail}) {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    events.insert(
      0,
      TimelineEvent(
        time: '$hour:$minute',
        title: title,
        type: type,
        detail: detail,
      ),
    );
  }

  @override
  void dispose() {
    _telemetrySubscription?.cancel();
    super.dispose();
  }
}
