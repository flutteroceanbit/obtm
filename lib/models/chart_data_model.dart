import 'add_time_slot_model.dart';

class ChartMonthDataModel {
  bool? status;
  String? message;
  List<TimeSlotData>? timeSlotData;

  ChartMonthDataModel({status, message, timeSlotData});

  ChartMonthDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      timeSlotData = <TimeSlotData>[];
      json['data'].forEach((v) {
        timeSlotData!.add(TimeSlotData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (timeSlotData != null) {
      data['data'] = timeSlotData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSlotData {
  String? date;
  List<TimeData>? timeSlots;
  String? intermediateTime;
  String? workingTime;

  TimeSlotData({date, timeSlots, intermediateTime, workingTime});

  TimeSlotData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['time_slots'] != null) {
      timeSlots = <TimeData>[];
      json['time_slots'].forEach((v) {
        timeSlots!.add(TimeData.fromJson(v));
      });
    }
    intermediateTime = json['intermediate_time'];
    workingTime = json['working_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (timeSlots != null) {
      data['time_slots'] = timeSlots!.map((v) => v.toJson()).toList();
    }
    data['intermediate_time'] = intermediateTime;
    data['working_time'] = workingTime;
    return data;
  }
}

/*
class TimeSlots {
  int? id;
  String? actionType;
  String? time;
  String? date;
  String? dateTime;
  String? timeDifference;
  int? userId;
  String? createdAt;
  String? updatedAt;

  TimeSlots(
      {id,
        actionType,
        time,
        date,
        dateTime,
        timeDifference,
        userId,
        createdAt,
        updatedAt});

  TimeSlots.fromJson(Map<String, dynamic> json) {
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
}*/
