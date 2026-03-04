class QrScannerModel {
  final QrScanStatus code; /// Código de respuesta
  final String rawValue; /// Valor del qr en string crudo

  QrScannerModel({
    required this.code,
    required this.rawValue,
  });
}

enum QrScanStatus {
  success,
  failed,
}