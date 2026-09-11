# SIPSVA

**Sistema Inteligente Preventivo de Señalización Vial Adaptativa**

Prototipo profesional de interfaz móvil para Android, desarrollado con Flutter
y Material Design 3. Está pensado para un centro moderno de monitoreo vial y
para la presentación de un proyecto de investigación o feria científica.

## Alcance de esta entrega

Incluye:

- Splash screen animada con identidad de SIPSVA.
- Dashboard con conexión ESP32, nivel de riesgo y métricas principales.
- Simulación visual del panel LED vial.
- Monitoreo individual de seis módulos/sensores.
- Historial en formato de línea de tiempo.
- Reporte visual de incidentes con diálogos y avisos seguros.
- Configuración local del prototipo.
- Modo demostración para modificar lluvia, noche, velocidad, congestión y humo.
- Pantalla de información del proyecto.
- Navegación inferior Material 3 con siete destinos.
- Componentes reutilizables, diseño responsive y accesibilidad semántica.
- `Esp32Service`: contrato de integración, con una implementación real para
  Flutter Web (`WebBleEsp32Service`) que recibe datos reales de la maqueta
  por Web Bluetooth.

No incluye:

- Backend o API.
- Base de datos.
- Lógica embebida para la ESP32 (eso vive en el firmware Arduino).
- Llamadas telefónicas.
- Integración Bluetooth nativa para Android/iOS (solo Flutter Web).

Todos los cambios del modo demostración existen solamente en memoria y se
reinician al cerrar la aplicación. Con el modo demostración desactivado y una
ESP32 real conectada por Bluetooth, el estado que ves en la app es el que
reporta la maqueta.

## Requisitos

- Flutter 3.44 o posterior con Dart 3.12.
- Android Studio o VS Code con el complemento Flutter.
- Android SDK y un emulador o dispositivo Android.

## Crear el host Android

El entorno en el que se generó esta entrega no tenía instalado el SDK de
Flutter. Por esa razón, el código de producto está completo, pero la carpeta
Android debe generarse una vez con la versión de Flutter instalada en el equipo
de desarrollo:

```bash
cd sipsva_flutter_app
./tool/bootstrap_android.sh
```

El script ejecuta:

```bash
flutter create --empty --platforms=android --org edu.sipsva --project-name sipsva .
flutter pub get
dart format .
flutter analyze
flutter test
```

Después:

```bash
flutter run
```

Para compilar un APK:

```bash
flutter build apk --release
```

## Arquitectura

```text
lib/
├── core/
│   ├── state/       Estado visual y alcance de demostración
│   └── theme/       Colores y ThemeData Material 3
├── models/          Riesgo, vía, incidentes y eventos
├── screens/         Una clase por pantalla
├── services/        Esp32Service + WebBleEsp32Service (Web Bluetooth)
├── utils/           Mapeos visuales de estados
├── widgets/         Componentes reutilizables
├── app.dart         Configuración de MaterialApp
└── main.dart        Punto de entrada
```

Flujo de dependencias:

```text
UI / Screens
     │
     ▼
Widgets reutilizables
     │
     ▼
SipsvaScope + DemoController ─────► Modelos
     │
     └── WebBleEsp32Service ──────► Web Bluetooth (navegador) ──► ESP32
```

La interfaz no depende de una tecnología concreta de transporte: `Esp32Service`
es el contrato, y `WebBleEsp32Service` es la implementación real para web. Si
en el futuro se necesita una versión Android/iOS nativa, se puede agregar otra
implementación del mismo contrato (por ejemplo con `flutter_blue_plus`) sin
tocar el resto de la interfaz.

## Recorrido recomendado para la demostración

1. Abrir **Inicio** y explicar el nivel de riesgo conjunto.
2. Ir a **Configuración** y activar/desactivar los escenarios.
3. Volver a **Inicio** para observar los colores y métricas.
4. Abrir **Panel** para mostrar la señal electrónica generada.
5. Revisar **Monitoreo** y los indicadores LED.
6. Consultar los nuevos eventos en **Historial**.
7. Demostrar **Emergencias**, aclarando que no se realiza una llamada real.

## Personalización pendiente

En `lib/screens/about_screen.dart`, reemplazar:

- Nombre de la institución educativa.
- Programa, curso o semillero.
- Nombres de integrantes.
- Nombre del docente asesor.

En `DemoController` puede cambiarse el teléfono de ejemplo y el identificador
predeterminado de la ESP32.

## Conexión real con la ESP32 (Web Bluetooth)

`lib/services/web_ble_esp32_service.dart` implementa `Esp32Service` usando la
API Web Bluetooth del navegador (paquete `flutter_web_bluetooth`), y se
conecta al mismo servicio/característica BLE que expone el firmware Arduino:

```cpp
#define SERVICE_UUID        "12345678-1234-1234-1234-1234567890AB"
#define CHARACTERISTIC_UUID "87654321-4321-4321-4321-BA0987654321"
```

Flujo:

1. En **Configuración**, desactiva "Modo demostración".
2. En **Inicio**, pulsa "Conectar ESP32 real". El navegador muestra su
   selector nativo de dispositivos Bluetooth cercanos.
3. Elige la maqueta (`SIPSVA-ESP32`). A partir de ahí, cada JSON que el
   firmware envía por `characteristic->notify()` se traduce en
   `DemoController.applyTelemetry()` a los mismos campos que usa toda la
   interfaz (lluvia, velocidad, congestión, humo, etc.).

Requisitos del navegador: **Chrome, Edge u Opera** (PC o Android) y **HTTPS**
(GitHub Pages ya cumple esto). **Safari y Firefox no soportan Web
Bluetooth** — en esos navegadores el botón de conexión real no podrá
emparejar con la maqueta.

Si tu firmware cambia los nombres de las claves del JSON o el formato del
estado de luz (`estadoLuz`), ajusta la traducción en
`DemoController.applyTelemetry()`.

## Publicar como demo web (GitHub Pages)

Este prototipo no depende de plugins nativos de Android, por lo que compila
igual de bien a Flutter Web:

```bash
flutter pub get
flutter build web --release --base-href /<REPO_NAME>/
```

El resultado en `build/web/` es un sitio estático que puedes alojar en
GitHub Pages, Netlify o Vercel. El repo ya incluye
`.github/workflows/deploy-web.yml`, que compila y publica automáticamente en
GitHub Pages en cada push a `main`:

1. Reemplaza `<REPO_NAME>` en ese workflow por el nombre real del
   repositorio (o déjalo en `/` si vas a usar un dominio propio o una
   user/organization page).
2. En GitHub, ve a **Settings → Pages → Source** y selecciona
   **GitHub Actions**.
3. Haz push a `main`; en unos minutos la demo queda disponible en
   `https://<usuario>.github.io/<REPO_NAME>/`.

Para quien abra el link desde un navegador sin Web Bluetooth (Safari,
Firefox), la app funciona igual como demo visual/modo simulado; solo el
botón de conexión real no estará disponible.

## Diseño

Paleta principal:

- Azul oscuro: `#0D47A1`
- Azul claro: `#42A5F5`
- Amarillo de señalización: `#FFC107`
- Verde: `#4CAF50`
- Rojo: `#E53935`

El logotipo se construye con widgets e iconos Material, por lo que no depende
de recursos gráficos externos.
