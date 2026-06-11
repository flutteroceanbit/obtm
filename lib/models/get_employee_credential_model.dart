class GetEmployeeCredentials {
  bool status;
  String message;
  CredentialData data;

  GetEmployeeCredentials({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetEmployeeCredentials.fromJson(Map<String, dynamic> json) =>
      GetEmployeeCredentials(
        status: json["status"],
        message: json["message"],
        data: CredentialData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class CredentialData {
  int id;
  int userId;
  String name;
  String email;
  String emailPassword;
  String skypeName;
  String skypePassword;
  DateTime createdAt;
  DateTime updatedAt;

  CredentialData({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.emailPassword,
    required this.skypeName,
    required this.skypePassword,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CredentialData.fromJson(Map<String, dynamic> json) => CredentialData(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        emailPassword: json["email_password"],
        skypeName: json["skype_name"],
        skypePassword: json["skype_password"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "email": email,
        "email_password": emailPassword,
        "skype_name": skypeName,
        "skype_password": skypePassword,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
