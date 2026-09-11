import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
 
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
 
import 'esp32_service.dart';
 
/// Implementación real de [Esp32Service] para Flutter Web.
///
/// Usa la API Web Bluetooth del navegador para conectarse directamente a la
/// maqueta (ESP32) y recibir, por notificaciones BLE, el mismo JSON que el
/// firmware arma en `crearJSON()` y envía en el `loop()` cada segundo.
///
/// IMPORTANTE: los UUID de abajo deben coincidir EXACTO con los definidos
/// en el firmware Arduino:
///
/// ```cpp
/// #define SERVICE_UUID        "12345678-1234-1234-1234-1234567890AB"
/// #define CHARACTERISTIC_UUID "87654321-4321-4321-4321-BA0987654321"
/// ```
///
/// Web Bluetooth normaliza los UUID a minúsculas, por eso aquí están en
/// minúscula aunque en el .ino estén en mayúscula (Arduino no distingue).
///
/// Requisitos del navegador: Chrome, Edge u Opera (PC o Android) y HTTPS
/// (o localhost). Safari y Firefox no implementan Web Bluetooth.
class WebBleEsp32Service implements Esp32Service {
  static const _serviceUuid = '12345678-1234-1234-1234-1234567890ab';
  static const _characteristicUuid = '87654321-4321-4321-4321-ba0987654321';
 
  BluetoothDevice? _device;
  StreamSubscription<ByteData>? _valueSubscription;
  StreamSubscription<bool>? _connectionSubscription;
  StreamController<Map<String, Object?>>? _telemetryController;
 
  /// True si el navegador actual soporta la API Web Bluetooth.
  bool get isSupported => FlutterWebBluetooth.instance.isBluetoothApiSupported;
 
  @override
  Future<void> connect() async {
    if (!isSupported) {
      throw Exception(
        'Este navegador no soporta Web Bluetooth. Usa Chrome, Edge u Opera '
        '(en PC o Android); Safari y Firefox no son compatibles.',
      );
    }
 
    await disconnect();
 
    final BluetoothDevice device;
    try {
      final options = RequestOptionsBuilder(
        <RequestFilterBuilder>[
          RequestFilterBuilder(services: <String>[_serviceUuid]),
        ],
      );
      device = await FlutterWebBluetooth.instance.requestDevice(options);
    } catch (error) {
      // El paquete lanza distintos tipos de error según el navegador
      // (usuario cancela el diálogo, no encuentra el dispositivo, etc.).
      // Los capturamos de forma genérica para no depender de tipos
      // específicos que pueden no existir en todas las versiones del
      // paquete.
      throw Exception(
        'No se pudo conectar a la maqueta Bluetooth: $error',
      );
    }
 
    await device.connect();
 
    final services = await device.discoverServices();
    BluetoothService? service;
    for (final candidate in services) {
      if (candidate.uuid == _serviceUuid) {
        service = candidate;
        break;
      }
    }
    if (service == null) {
      device.disconnect();
      throw Exception(
        'La maqueta no expone el servicio BLE esperado ($_serviceUuid).',
      );
    }
 
    final characteristic = await service.getCharacteristic(
      _characteristicUuid,
    );
    await characteristic.startNotifications();
 
    final controller = StreamController<Map<String, Object?>>.broadcast();
 
    _valueSubscription = characteristic.value.listen(
      (byteData) => _handleValue(controller, byteData),
      onError: controller.addError,
    );
 
    _connectionSubscription = device.connected.listen((connected) {
      if (!connected) {
        controller.addError(
          Exception('Se perdió la conexión Bluetooth con la maqueta.'),
        );
      }
    });
 
    _device = device;
    _telemetryController = controller;
  }
 
  void _handleValue(
    StreamController<Map<String, Object?>> controller,
    ByteData byteData,
  ) {
    try {
      final bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );
      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is Map<String, Object?>) {
        controller.add(decoded);
      }
    } catch (error) {
      controller.addError(
        Exception('JSON inválido recibido por BLE: $error'),
      );
    }
  }
 
  @override
  Future<void> disconnect() async {
    await _valueSubscription?.cancel();
    _valueSubscription = null;
    await _connectionSubscription?.cancel();
    _connectionSubscription = null;
    _device?.disconnect();
    _device = null;
    await _telemetryController?.close();
    _telemetryController = null;
  }
 
  @override
  Stream<Map<String, Object?>> get telemetry =>
      _telemetryController?.stream ?? const Stream<Map<String, Object?>>.empty();
}
 
