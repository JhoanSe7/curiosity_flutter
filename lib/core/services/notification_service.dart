import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  Logger log = Logger('NotificationService');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      await _initializeLocalNotifications();
      await requestPermissionNotification();
      _onForegroundMessage();
    } catch (e) {
      log.warning("No se pudo inicializar el servicio de notificaciones $e");
    }
  }

  Future<void> _initializeLocalNotifications() async {
    // Configuración para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Manejar cuando el usuario toca la notificación
        _handleLocalNotificationTap(response);
      },
    );

    // Crear canal de notificación para Android
    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'Notificaciones Importantes', // nombre
      description: 'Canal para notificaciones importantes',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestPermissionNotification() async {
    NotificationSettings settings = await messaging.getNotificationSettings();

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
    log.info('User granted permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await generateTokenFMC();

      final pref = await SharedPreferences.getInstance();
      messaging.onTokenRefresh.listen((newToken) {
        pref.setString('tokenFCM', newToken);
        log.info('TokenFCM actualizado: $newToken');
      });
    }
  }

  Future<void> generateTokenFMC() async {
    final pref = await SharedPreferences.getInstance();
    String? tokenFCM = pref.getString('tokenFCM');
    log.info("TokenFCM: $tokenFCM");
    if ((tokenFCM ?? "").isEmpty) {
      final token = await messaging.getToken();
      pref.setString('tokenFCM', token ?? "");
      log.info("TokenFCM nuevo: $token");
    }
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });
    _checkInitialMessage();
  }

  Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Aquí puedes navegar a una pantalla específica según message.data
    log.info("onTap Notification ${message.data}");
  }

  void _handleLocalNotificationTap(NotificationResponse response) {
    log.info("Local notification tapped: ${response.payload}");
    // Aquí puedes navegar según el payload
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    log.info('Message: ${message.notification?.title}');

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'Notificaciones Importantes',
      channelDescription: 'Canal para notificaciones importantes',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: message.hashCode,
      title: message.notification?.title ?? 'Curiosity',
      body: message.notification?.body ?? '',
      notificationDetails: notificationDetails,
      payload: message.data.toString(),
    );
  }
}

final notificationSvc = NotificationService();
