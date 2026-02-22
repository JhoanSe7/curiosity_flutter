class LobbyPlayerModel {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String role;
  final String initials;

  LobbyPlayerModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.initials,
  });

  factory LobbyPlayerModel.fromJson(Map<String, dynamic> json) {
    return LobbyPlayerModel(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? '',
      initials: json['initials'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'role': role,
    'initials': initials,
  };
}