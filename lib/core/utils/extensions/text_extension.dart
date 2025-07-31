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
}
