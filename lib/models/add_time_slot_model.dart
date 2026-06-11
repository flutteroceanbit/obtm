class AddTimeSlotModel {
  bool? status;
  String? message;
  TimeData? timeData;

  AddTimeSlotModel({status, message, timeData});

  AddTimeSlotModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    timeData = json['data'] != null ? TimeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (timeData != null) {
      data['data'] = timeData!.toJson();
    }
    return data;
  }
}

class TimeData {
  int? id;
  String? actionType;
  String? time;
  String? date;
  String? dateTime;
  String? timeDifference;
  int? userId;
  String? createdAt;
  String? updatedAt;

  TimeData(
      {id,
      actionType,
      time,
      date,
      dateTime,
      timeDifference,
      userId,
      createdAt,
      updatedAt});

  TimeData.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['action_type'] = actionType;
    data['time'] = time;
    data['date'] = date;
    data['date_time'] = dateTime;
    data['time_difference'] = timeDifference;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
