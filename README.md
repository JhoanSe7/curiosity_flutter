<div align="center">

# 🎓 Curiosity
### Aplicación Móvil Educativa para Evaluaciones Interactivas

[![Flutter](https://img.shields.io/badge/Flutter-3.38.7-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey?style=for-the-badge)](https://flutter.dev/multi-platform)

*Desarrollado para las Unidades Tecnológicas de Santander — Bucaramanga, Colombia*

</div>

---

## 📱 ¿Qué es Curiosity?

Curiosity es una aplicación móvil educativa que transforma la forma en que docentes y estudiantes viven las evaluaciones. Los docentes pueden crear cuestionarios manualmente o generarlos automáticamente con inteligencia artificial. Los estudiantes responden en tiempo real y reciben retroalimentación inmediata con explicación de cada respuesta.

---

## ✨ Funcionalidades

| Funcionalidad | Descripción |
|---|---|
| 🔐 Autenticación | Registro e inicio de sesión seguro |
| 🤖 Generación con IA | Crea cuestionarios automáticamente por tema |
| ✍️ Creación manual | Control total sobre cada pregunta |
| ⚡ Quiz en tiempo real | Evaluaciones sincronizadas mediante WebSocket |
| 📱 Código QR | Únete a una sala escaneando el código |
| 💬 Retroalimentación | Explicación inmediata de cada respuesta |
| 📊 Reportes | Descarga los resultados de cada sesión |
| 🌐 Multiplataforma | Funciona en iOS y Android |

---

## 🛠️ Requisitos previos

Antes de comenzar, asegúrate de tener instalado:

- ✅ **Flutter SDK 3.38.7**
- ✅ **Dart SDK** (incluido con Flutter)
- ✅ **Android Studio** o **VS Code** con la extensión de Flutter
- ✅ Dispositivo físico o emulador Android / iOS
- ✅ **Xcode** *(solo para compilar en iOS, requiere macOS)*

---

## 🚀 Instalación

**1. Clona el repositorio**

```bash
git clone https://github.com/JhoanSe7/curiosity_flutter.git
cd curiosity_flutter
```

**2. Cambia a la rama de desarrollo**

```bash
git checkout develop
```

**3. Instala las dependencias**

```bash
flutter pub get
```

**4. Verifica tu entorno**

```bash
flutter doctor
```

---

## ⚙️ Configuración del entorno

La URL del backend y del WebSocket se configuran en:

```
lib/core/constants/config.dart
```

Cambia el entorno según tus necesidades:

```dart
static final Environment env = Environment.development; // o Environment.production
```

| Entorno | URL |
|---|---|
| `development` | `http://<IP_LOCAL>:9070/api/` |
| `production` | `https://<URL_DEL_SERVIDOR>/api/` |

> 💡 **Para desarrollo local:** reemplaza `<IP_LOCAL>` con la IP de la máquina donde corre el backend en la misma red.
>
> 🏭 **Para producción:** reemplaza `<URL_DEL_SERVIDOR>` con la URL del servidor institucional donde esté desplegado el backend.

> ⚠️ **Nota:** Durante el desarrollo del proyecto se utilizó Railway como entorno de pruebas. Para una implementación formal se recomienda alojar el backend en un servidor de producción con garantías de disponibilidad y seguridad acordes a un sistema educativo institucional.

---

## ▶️ Ejecución

```bash
# Ejecutar en modo debug
flutter run

# Listar dispositivos disponibles
flutter devices

# Ejecutar en un dispositivo específico
flutter run -d <device_id>
```

---

## 📦 Compilación

```bash
# APK para Android
flutter build apk --release

# Build para iOS (requiere macOS y Xcode)
flutter build ios --release
```

---

## 📁 Estructura del proyecto

```
curiosity_flutter/
├── android/                        # Configuración nativa Android
├── ios/                            # Configuración nativa iOS
├── lib/                            # Código fuente principal
│   ├── core/                       # Configuraciones y utilidades globales
│   │   └── constants/
│   │       └── config.dart         # URLs y configuración del entorno
│   ├── features/                   # Módulos por funcionalidad
│   │   ├── auth/                   # Registro e inicio de sesión
│   │   ├── home/                   # Dashboard principal
│   │   ├── main/presentation/      # Presentación principal
│   │   ├── qr_scanner/             # Escaneo de código QR
│   │   ├── questionaries/          # Creación y gestión de cuestionarios
│   │   └── room/                   # Ejecución del quiz en tiempo real
│   ├── app.dart                    # Configuración principal de la app
│   ├── firebase_options.dart       # Configuración de Firebase
│   └── main.dart                   # Punto de entrada
├── pubspec.yaml                    # Dependencias del proyecto
└── README.md                       # Este archivo
```

> El proyecto aplica **Clean Architecture**, separando la lógica de negocio de la interfaz y las fuentes de datos externas.

---

## 🧰 Tecnologías utilizadas

- **Flutter 3.38.7** — Framework multiplataforma
- **Dart** — Lenguaje de programación
- **STOMP sobre WebSocket** — Comunicación en tiempo real
- **HTTP** — Comunicación con la API REST
- **Firebase** — Servicios de notificaciones

---

## 👥 Autores

| Nombre | Programa |
|---|---|
| Carlos Alberto Santos Rodríguez | Ingeniería de Sistemas |
| Jhoan Sebastián Silva Vargas | Ingeniería de Sistemas |

*Trabajo de grado — Unidades Tecnológicas de Santander, 2026*

---

<div align="center">
Desarrollado con ❤️ en Bucaramanga, Colombia
</div>