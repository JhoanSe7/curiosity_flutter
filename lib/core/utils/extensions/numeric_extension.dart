extension NumericExtension on num {
  String toTime({bool withUnit = false}) {
    var time = this;
    var minutes = time ~/ 60;
    var seconds = time % 60;
    var unit = minutes > 0 ? "minutos" : "segundos";
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} ${withUnit ? unit : ''}";
  }
}
