class UserDetailModel {
  bool? status;
  String? message;
  UserData? userData;

  UserDetailModel({status, message, userData});

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userData = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (userData != null) {
      data['data'] = userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? employeeId;
  String? email;
  String? phone;
  String? alterPhone;
  String? imageUrl;
  String? docUrl;
  bool? isAdmin;
  bool? isPhoneVerified;
  bool? isEmailVerified;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? recordDeleted;
  PersonalDetailData? personalData;
  ContactDetail? contactDetail;

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
      personalData,
      contactDetail});

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
    personalData = json['personal_detail'] != null
        ? PersonalDetailData.fromJson(json['personal_detail'])
        : null;
    contactDetail = json['contact_detail'] != null
        ? ContactDetail.fromJson(json['contact_detail'])
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
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['record_deleted'] = recordDeleted;
    if (personalData != null) {
      data['personal_detail'] = personalData!.toJson();
    }
    if (contactDetail != null) {
      data['contact_detail'] = contactDetail!.toJson();
    }
    return data;
  }
}

class PersonalDetailData {
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

  PersonalDetailData(
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

  PersonalDetailData.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
}

class ContactDetail {
  int? id;
  String? email;
  String? parentsPhone;
  String? permanentAddress;
  String? correspondenceAddress;
  int? userId;
  String? createdAt;
  String? updatedAt;

  ContactDetail(
      {id,
      email,
      parentsPhone,
      permanentAddress,
      correspondenceAddress,
      userId,
      createdAt,
      updatedAt});

  ContactDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    parentsPhone = json['parents_phone'];
    permanentAddress = json['permanent_address'];
    correspondenceAddress = json['correspondence_address'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['parents_phone'] = parentsPhone;
    data['permanent_address'] = permanentAddress;
    data['correspondence_address'] = correspondenceAddress;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
/*
class UserDetailModel {
  bool? status;
  String? message;
  UserData? data;

  UserDetailModel({status, message, data});

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (data != null) {
      data['data'] = data!.toJson();
    }
    return data;
  }
}

class UserData {
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
        recordDeleted});

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
    return data;
  }
}
*/
