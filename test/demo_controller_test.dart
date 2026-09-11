import 'package:flutter_test/flutter_test.dart';
import 'package:sipsva/core/state/demo_controller.dart';
import 'package:sipsva/models/risk_level.dart';

void main() {
  group('DemoController', () {
    test('inicia con lluvia y riesgo medio', () {
      final controller = DemoController();

      expect(controller.raining, isTrue);
      expect(controller.riskLevel, RiskLevel.medium);
      expect(controller.panelMessage, 'VÍA MOJADA');
    });

    test('el humo eleva el riesgo y actualiza el panel', () {
      final controller = DemoController()..toggleSmoke();

      expect(controller.smokeDetected, isTrue);
      expect(controller.riskLevel, RiskLevel.high);
      expect(controller.panelMessage, 'HUMO DETECTADO');
      expect(controller.events.first.title, 'Humo detectado');
    });

    test('el modo de velocidad modifica solamente el estado local', () {
      final controller = DemoController()..toggleSpeeding();

      expect(controller.speeding, isTrue);
      expect(controller.currentSpeed, greaterThan(controller.maximumSpeed));
      expect(controller.panelMessage, 'REDUZCA VELOCIDAD');
    });
  });
}
