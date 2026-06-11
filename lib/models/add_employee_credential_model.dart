class AddEmployeeCredentials {
  bool status;
  String message;
  Data data;

  AddEmployeeCredentials({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddEmployeeCredentials.fromJson(Map<String, dynamic> json) =>
      AddEmployeeCredentials(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String userId;
  String name;
  String email;
  String emailPassword;
  String skypeName;
  String skypePassword;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.userId,
    required this.name,
    required this.email,
    required this.emailPassword,
    required this.skypeName,
    required this.skypePassword,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        emailPassword: json["email_password"],
        skypeName: json["skype_name"],
        skypePassword: json["skype_password"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "email": email,
        "email_password": emailPassword,
        "skype_name": skypeName,
        "skype_password": skypePassword,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
