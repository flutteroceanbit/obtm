import 'package:oceanbit_timeclock/models/user_detail_model.dart';

class BirthdayOfMonthModel {
  bool? status;
  String? message;
  List<UserData>? data;

  BirthdayOfMonthModel({status, message, data});

  BirthdayOfMonthModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data!.map((v) => v.toJson()).toList();
    return data;
  }
}

/*
class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? employeeId;
  String? email;
  String? phone;
  Null? alterPhone;
  String? imageUrl;
  Null? docUrl;
  bool? isAdmin;
  bool? isPhoneVerified;
  bool? isEmailVerified;
  Null? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? recordDeleted;
  PersonalDetail? personalDetail;

  UserData(
      {id,
        firstName,
        lastName,
        employeeId,
        email,
        phone,
        alterPhone,
        imageUrl,
        docUrl,
        isAdmin,
        isPhoneVerified,
        isEmailVerified,
        emailVerifiedAt,
        createdAt,
        updatedAt,
        recordDeleted,
        personalDetail});

  UserData.fromJson(Map<String, dynamic> json) {
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
    personalDetail = json['personal_detail'] != null
        ? new PersonalDetail.fromJson(json['personal_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['record_deleted'] = recordDeleted;
    if (personalDetail != null) {
      data['personal_detail'] = personalDetail!.toJson();
    }
    return data;
  }
}

class PersonalDetail {
  int? id;
  String? middleName;
  String? dob;
  String? fatherFullName;
  String? fatherOccupation;
  String? education;
  String? gender;
  String? bloodGroup;
  String? aadharCard;
  String? panCard;
  int? userId;
  String? createdAt;
  String? updatedAt;

  PersonalDetail(
      {id,
        middleName,
        dob,
        fatherFullName,
        fatherOccupation,
        education,
        gender,
        bloodGroup,
        aadharCard,
        panCard,
        userId,
        createdAt,
        updatedAt});

  PersonalDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    middleName = json['middle_name'];
    dob = json['dob'];
    fatherFullName = json['father_full_name'];
    fatherOccupation = json['father_occupation'];
    education = json['education'];
    gender = json['gender'];
    bloodGroup = json['blood_group'];
    aadharCard = json['aadhar_card'];
    panCard = json['pan_card'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['middle_name'] = middleName;
    data['dob'] = dob;
    data['father_full_name'] = fatherFullName;
    data['father_occupation'] = fatherOccupation;
    data['education'] = education;
    data['gender'] = gender;
    data['blood_group'] = bloodGroup;
    data['aadhar_card'] = aadharCard;
    data['pan_card'] = panCard;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}*/
