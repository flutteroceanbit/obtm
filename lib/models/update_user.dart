import 'package:oceanbit_timeclock/models/user_list_model.dart';

class UpdateUserModel {
  bool? status;
  String? message;
  UserModelData? data;

  UpdateUserModel({this.status, this.message, this.data});

  UpdateUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
