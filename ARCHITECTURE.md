# Arquitectura de interfaz

## Jerarquía principal de widgets

```text
SipsvaBootstrap
└── SipsvaScope (InheritedNotifier)
    └── MaterialApp
        └── SplashScreen
            └── HomeShell
                ├── AppBar + estado ESP32
                ├── IndexedStack
                │   ├── DashboardScreen
                │   ├── IntelligentPanelScreen
                │   ├── MonitoringScreen
                │   ├── HistoryScreen
                │   ├── IncidentsScreen
                │   ├── SettingsScreen
                │   └── AboutScreen
                ├── FloatingActionButton (Inicio)
                └── NavigationBar (7 destinos)
```

## Decisiones de UX

- La jerarquía visual comienza con el riesgo global, seguido por sus causas.
- Verde representa operación segura; amarillo, precaución; rojo, peligro.
- El estado de conexión permanece visible en la cabecera de todas las vistas.
- El panel LED elimina elementos visuales secundarios para parecer una señal
  electrónica real.
- Las acciones peligrosas son demostrativas y siempre explican su alcance.
- La navegación se desplaza horizontalmente en teléfonos estrechos para
  conservar los siete destinos solicitados sin reducir sus áreas táctiles.
- Las pantallas admiten teléfono y tablet mediante límites de ancho,
  `LayoutBuilder`, `Wrap` y composiciones de una o dos columnas.

## Estado de demostración

`DemoController` es un `ChangeNotifier` sin persistencia. Calcula:

- Riesgo combinado.
- Estado de la vía.
- Mensaje del panel.
- Lecturas visibles.
- Nuevos eventos del historial.

No contiene protocolos IoT ni acceso a red.

## Punto de integración IoT

`Esp32Service` define el contrato de transporte:

```dart
Future<void> connect();
Future<void> disconnect();
Stream<Map<String, Object?>> get telemetry;
```

`WebBleEsp32Service` (`lib/services/web_ble_esp32_service.dart`) es la
implementación real para Flutter Web: usa la API Web Bluetooth del
navegador para conectarse al mismo servicio/característica BLE que anuncia
el firmware Arduino, y emite cada JSON recibido como `Map<String, Object?>`
en `telemetry`.

`DemoController.applyTelemetry()` toma ese mapa y actualiza el mismo estado
que usan todas las pantallas (lluvia, velocidad, congestión, humo, etc.),
generando eventos de historial cuando una condición cambia.

Pendiente si se necesita en el futuro:

1. Una implementación nativa de `Esp32Service` para Android/iOS (ej. con
   `flutter_blue_plus`), ya que Web Bluetooth solo funciona en Flutter Web.
2. Validación de rangos/pérdida de señal más estricta que la actual.
3. Reconexión automática si la maqueta se desconecta a mitad de sesión.
