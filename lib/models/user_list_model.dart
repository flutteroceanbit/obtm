/*
class UserListModel {
  bool? status;
  String? message;
  List<Data>? data;

  UserListModel({this.status, this.message, this.data});

  UserListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? employeeId;
  String? email;
  String? phone;
  dynamic alterPhone;
  String? imageUrl;
  dynamic docUrl;
  bool? isAdmin;
  bool? isPhoneVerified;
  bool? isEmailVerified;
  dynamic emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? recordDeleted;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.employeeId,
        this.email,
        this.phone,
        this.alterPhone,
        this.imageUrl,
        this.docUrl,
        this.isAdmin,
        this.isPhoneVerified,
        this.isEmailVerified,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.recordDeleted});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    employeeId = json['employee_id'];
    email = json['email'];
    phone = json['phone'];
    alterPhone = json['alter_phone'];
    imageUrl = json['image_url'];
    docUrl = json['doc_url'];
    isAdmin = json['is_admin'];
    isPhoneVerified = json['is_phone_verified'];
    isEmailVerified = json['is_email_verified'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    recordDeleted = json['record_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['employee_id'] = this.employeeId;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['alter_phone'] = this.alterPhone;
    data['image_url'] = this.imageUrl;
    data['doc_url'] = this.docUrl;
    data['is_admin'] = this.isAdmin;
    data['is_phone_verified'] = this.isPhoneVerified;
    data['is_email_verified'] = this.isEmailVerified;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['record_deleted'] = this.recordDeleted;
    return data;
  }
}
*/
import 'add_time_slot_model.dart';

class UserListModel {
  bool? status;
  String? message;
  List<UserModelData>? data;

  UserListModel({this.status, this.message, this.data});

  UserListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserModelData>[];
      json['data'].forEach((v) {
        data!.add(UserModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserModelData {
  int? id;
  String? firstName;
  String? lastName;
  String? employeeId;
  String? email;
  String? phone;
  String? alterPhone;
  String? imageUrl;
  dynamic docUrl;
  bool? isAdmin;
  bool? isPhoneVerified;
  bool? isEmailVerified;
  int? isActive;
  dynamic emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? recordDeleted;
  TimeData? lastTimeSlot;

  UserModelData(
      {this.id,
      this.firstName,
      this.lastName,
      this.employeeId,
      this.email,
      this.phone,
      this.alterPhone,
      this.imageUrl,
      this.docUrl,
      this.isAdmin,
      this.isPhoneVerified,
      this.isEmailVerified,
      this.isActive,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.recordDeleted,
      this.lastTimeSlot});

  UserModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    employeeId = json['employee_id'];
    email = json['email'];
    phone = json['phone'];
    alterPhone = json['alter_phone'];
    imageUrl = json['image_url'];
    docUrl = json['doc_url'];
    isAdmin = json['is_admin'];
    isPhoneVerified = json['is_phone_verified'];
    isEmailVerified = json['is_email_verified'];
    isActive = json['is_active'] is String
        ? int.parse(json['is_active'])
        : json['is_active'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    recordDeleted = json['record_deleted'];
    lastTimeSlot = json['last_time_slot'] != null
        ? TimeData.fromJson(json['last_time_slot'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['employee_id'] = employeeId;
    data['email'] = email;
    data['phone'] = phone;
    data['alter_phone'] = alterPhone;
    data['image_url'] = imageUrl;
    data['doc_url'] = docUrl;
    data['is_admin'] = isAdmin;
    data['is_phone_verified'] = isPhoneVerified;
    data['is_email_verified'] = isEmailVerified;
    data['is_active'] = isActive;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['record_deleted'] = recordDeleted;
    if (lastTimeSlot != null) {
      data['last_time_slot'] = lastTimeSlot!.toJson();
    }
    return data;
  }
}

/*class LastTimeSlot {
  int? id;
  String? actionType;
  String? time;
  String? date;
  String? dateTime;
  String? timeDifference;
  int? userId;
  String? createdAt;
  String? updatedAt;

  LastTimeSlot(
      {this.id,
        this.actionType,
        this.time,
        this.date,
        this.dateTime,
        this.timeDifference,
        this.userId,
        this.createdAt,
        this.updatedAt});

  LastTimeSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    actionType = json['action_type'];
    time = json['time'];
    date = json['date'];
    dateTime = json['date_time'];
    timeDifference = json['time_difference'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['action_type'] = this.actionType;
    data['time'] = this.time;
    data['date'] = this.date;
    data['date_time'] = this.dateTime;
    data['time_difference'] = this.timeDifference;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}*/
