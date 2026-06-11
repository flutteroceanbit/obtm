class AddUpdatePersonalDetailModel {
  bool? status;
  String? message;
  PersonalDetail? data;

  AddUpdatePersonalDetailModel({status, message, data});

  AddUpdatePersonalDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PersonalDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data!.toJson();
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
