import 'package:curiosity_flutter/core/design/tokens/colors.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_type.dart';
import 'package:flutter/material.dart';

class Config {
  static final Environment env = Environment.production;

  static final String apiUrl = backUrl[env] ?? "";
  static final String wsBaseUrl = wsUrl[env] ?? "";

  static String _token = "";
  static void setToken(String token) => _token = token;
  static void clearToken() => _token = "";

  static Map<String, String> get headers => {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (_token.isNotEmpty) "Authorization": "Bearer $_token",
      };

  static final Map<Environment, String> backUrl = {
    Environment.development: "http://192.168.0.23:9070/api/",
    Environment.production: "https://back-end-production-8c6c.up.railway.app/api/",
  };

  static final Map<Environment, String> wsUrl = {
    Environment.development: "http://192.168.0.23:9070",
    Environment.production: "https://back-end-production-8c6c.up.railway.app",
  };

  static final List<QuestionDataType> questionsType = [
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
    // QuestionDataType(
    //   "Respuesta Abierta",
    //   "Respuesta libre",
    //   colors.gradientMagenta,
    //   Icons.description_outlined,
    //   QuestionType.OPEN_ANSWER,
    // ),
  ];

  static final List<List<Color>> allColors = [
    colors.gradientBlue,
    colors.gradientGreen,
    colors.gradientViolet,
    colors.gradientOrange,
  ];

  static final List<String> fakeNames = ["Santiago", "Juliana", "Pedro", "Maria", "Carlos", "Sofia"];
  static final List<String> fakeLastNames = ["Rojas", "Fonseca", "Vargas", "Arenas", "Hernandez", "Gutierrez"];

  static final String urlTYC = "https://drive.google.com/file/d/1lR-ezdwla9Mnp_bpHXhWrtVxH3Ok7dtY/view?usp=sharing";
}

enum Environment {
  development,
  production,
}
