class DailyReportModel {
  bool? status;
  String? message;
  Data? data;

  DailyReportModel({status, message, data});

  DailyReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data!.toJson();
    return data;
  }
}

class Data {
  int? id;
  String? date;
  String? totalTime;
  String? intermediateTime;
  String? reportText;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Data(
      {id,
      date,
      totalTime,
      reportText,
      userId,
      createdAt,
      updatedAt,
      intermediateTime});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    totalTime = json['total_time'];
    intermediateTime = json['intermediate_time'];
    reportText = json['report_text'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['total_time'] = totalTime;
    data['intermediate_time'] = intermediateTime;
    data['report_text'] = reportText;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
