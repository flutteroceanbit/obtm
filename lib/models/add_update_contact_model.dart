class AddUpdateContactDetailModel {
  bool? status;
  String? message;
  ContactData? data;

  AddUpdateContactDetailModel({status, message, data});

  AddUpdateContactDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ContactData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data!.toJson();
    return data;
  }
}

class ContactData {
  int? id;
  String? email;
  String? parentsPhone;
  String? permanentAddress;
  String? correspondenceAddress;
  int? userId;
  String? createdAt;
  String? updatedAt;

  ContactData(
      {id,
      email,
      parentsPhone,
      permanentAddress,
      correspondenceAddress,
      userId,
      createdAt,
      updatedAt});

  ContactData.fromJson(Map<String, dynamic> json) {
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
