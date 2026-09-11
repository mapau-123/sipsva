/// Contrato preparado para una futura integración con la ESP32.
///
/// Este prototipo no implementa Wi-Fi, Bluetooth, backend ni lectura de
/// sensores. La capa visual depende de [DemoController] y datos en memoria.
abstract interface class Esp32Service {
  Future<void> connect();

  Future<void> disconnect();

  Stream<Map<String, Object?>> get telemetry;
}
