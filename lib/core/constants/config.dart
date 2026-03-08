import 'package:curiosity_flutter/core/design/tokens/colors.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_type.dart';
import 'package:flutter/material.dart';

class Config {
  static final String apiUrl = "https://back-end-production-8c6c.up.railway.app/api/";
  static final String wsBaseUrl = "https://back-end-production-8c6c.up.railway.app";
  static final Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": 'application/json',
  };
  static String versionApp = "1.0.0";

  static List<QuestionDataType> questionsType = [
    QuestionDataType(
      "Selección Múltiple",
      "Varias respuestas correctas",
      colors.gradientPurple,
      Icons.check_box_outlined,
      QuestionType.MULTIPLE_SELECTION,
    ),
    QuestionDataType(
      "Única Selección",
      "Solo una respuesta correcta",
      colors.gradientBlue,
      Icons.circle_outlined,
      QuestionType.SINGLE_SELECTION,
    ),
    QuestionDataType(
      "Rellenar Espacios",
      "Completar la frase",
      colors.gradientYellow,
      Icons.square_outlined,
      QuestionType.FILL_IN_THE_BLANK,
    ),
    QuestionDataType(
      "Verdadero o Falso",
      "Pregunta de si o no",
      colors.gradientPrimary,
      Icons.help_outline_sharp,
      QuestionType.TRUE_FALSE,
    ),
    QuestionDataType(
      "Respuesta Abierta",
      "Respuesta libre",
      colors.gradientMagenta,
      Icons.description_outlined,
      QuestionType.OPEN_ANSWER,
    ),
  ];
}
