import 'package:curiosity_flutter/core/services/web_socket/models/event_type.dart';
import 'package:intl/intl.dart';

extension TextExtension on String {
  bool get isEmail {
    final regExp = RegExp(r'^(?!_)(?!.*[._-]{2})[\w.-]+@(?!.*[._-]{2})[\w.-]+\.[a-zA-Z]{2,}$');
    return regExp.hasMatch(this);
  }

  String get cleaned {
    return replaceAll(
            RegExp(
              r'[^\w\s]',
            ),
            '')
        .replaceAll(
            RegExp(
              r'[\u{1F600}-\u{1F64F}]|' // emoticonos
              r'[\u{1F300}-\u{1F5FF}]|' // símbolos y pictogramas
              r'[\u{1F680}-\u{1F6FF}]|' // transporte y mapas
              r'[\u{2600}-\u{26FF}]|' // símbolos misceláneos
              r'[\u{2700}-\u{27BF}]', // símbolos Dingbats
              unicode: true,
            ),
            '')
        .trim();
  }

  EventType toEvent() {
    switch (this) {
      case 'PLAYER_JOINED':
      case 'HOST_PLAYER_JOINED':
      case 'HOST_CONNECTED':
        return EventType.userJoined;
      case 'PLAYER_LEFT':
      case 'HOST_PLAYER_LEFT':
        return EventType.userLeft;
      case 'QUIZ_STARTED':
        return EventType.start;
      case 'LOBBY_CLOSED':
        return EventType.close;
      case 'LOBBY_ERROR':
        return EventType.error;
      case 'USER_UPDATED':
      case 'QUIZ_FINISH_COMPLETE':
        return EventType.userUpdate;
      case 'QUIZ_FORCE_FINISHED':
        return EventType.forceFinish;
      case 'QUIZ_RESULT':
        return EventType.quizResult;
      default:
        return EventType.unknown;
    }
  }

  String get customDate {
    final date = DateTime.parse(this);
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final lastDay = today.subtract(const Duration(days: 1));

    final current = DateTime(date.year, date.month, date.day);

    final hora = DateFormat('hh:mm a').format(date);
    final newDate = DateFormat('dd MMM yyyy', 'es').format(date);

    if (current == today) {
      return 'Hoy, $hora';
    } else if (current == lastDay) {
      return 'Ayer, $hora';
    } else {
      return newDate;
    }
  }

  String get cleanString => replaceAll("*&*", ", ");
}
