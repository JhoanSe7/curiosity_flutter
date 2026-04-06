# Curiosity — Aplicación Móvil Educativa

Aplicación móvil educativa desarrollada en Flutter para las Unidades Tecnológicas de Santander. Permite crear y aplicar cuestionarios interactivos con soporte de inteligencia artificial, retroalimentación instantánea y ejecución de evaluaciones en tiempo real.

## Requisitos previos

- Flutter SDK **3.38.7**
- Dart SDK (incluido con Flutter)
- Android Studio o VS Code con extensión de Flutter
- Dispositivo físico o emulador Android / iOS
- Xcode (solo para compilar en iOS, requiere macOS)

## Instalación

1. Clonar el repositorio:

```bash
git clone https://github.com/JhoanSe7/curiosity_flutter.git
cd curiosity_flutter
```

2. Verificar que se está en la rama correcta:

```bash
git checkout develop
```

3. Instalar las dependencias:

```bash
flutter pub get
```

4. Verificar que el entorno esté configurado correctamente:

```bash
flutter doctor
```

## Configuración del entorno

La configuración de la URL del backend y del WebSocket se encuentra en:

```
lib/core/constants/config.dart
```

Dentro de ese archivo se pueden definir dos entornos:

```dart
static final Environment env = Environment.development; // Cambiar a production para producción
```

Las URLs por entorno están definidas así:

```dart
// Desarrollo (red local)
Environment.development: "http://<IP_LOCAL>:9070/api/"

// Producción (Railway)
Environment.production: "https://back-end-production-8c6c.up.railway.app/api/"
```

Para desarrollo local, reemplaza `<IP_LOCAL>` con la dirección IP de la máquina donde corre el backend en la misma red.

## Ejecución

Para ejecutar la aplicación en modo debug:

```bash
flutter run
```

Para ejecutar en un dispositivo específico:

```bash
flutter devices          # Lista los dispositivos disponibles
flutter run -d <device_id>
```

## Compilación

Para generar el APK de Android:

```bash
flutter build apk --release
```

Para generar el build de iOS (requiere macOS y Xcode):

```bash
flutter build ios --release
```

## Estructura del proyecto

El proyecto sigue los principios de **Clean Architecture**, organizando el código en capas independientes:

```
lib/
├── core/                         # Configuraciones y utilidades globales
│   └── constants/
│       └── config.dart           # URLs del backend y configuración del entorno
├── features/                     # Módulos organizados por funcionalidad
│   ├── auth/                     # Registro e inicio de sesión
│   ├── home/                     # Dashboard principal
│   ├── main/presentation/        # Presentación principal
│   ├── qr_scanner/               # Escaneo de código QR
│   ├── questionaries/            # Creación y gestión de cuestionarios
│   └── room/                     # Ejecución del quiz en tiempo real
├── app.dart                      # Configuración principal de la aplicación
├── firebase_options.dart         # Configuración de Firebase
└── main.dart                     # Punto de entrada de la aplicación
```

## Funcionalidades principales

- Registro e inicio de sesión de usuarios
- Creación de cuestionarios de forma manual
- Generación automática de cuestionarios mediante inteligencia artificial
- Ejecución de quizzes en tiempo real mediante WebSocket
- Unirse a salas mediante roomCode o código QR
- Retroalimentación instantánea con explicación de respuestas
- Descarga de reportes de resultados
- Compatible con iOS y Android

## Tecnologías utilizadas

- Flutter 3.38.7
- Dart
- STOMP sobre WebSocket para comunicación en tiempo real
- HTTP para comunicación con la API REST
- Firebase