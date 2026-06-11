import 'add_time_slot_model.dart';

class GetAllTimeSlotModel {
  bool? status;
  String? message;
  List<TimeData>? timeData;

  GetAllTimeSlotModel({status, message, timeData});

  GetAllTimeSlotModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['TimeData'] != null) {
      timeData = <TimeData>[];
      json['TimeData'].forEach((v) {
        timeData!.add(TimeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> timedata = <String, dynamic>{};
    timedata['status'] = status;
    timedata['message'] = message;
    if (timeData != null) {
      timedata['TimeData'] = timeData!.map((v) => v.toJson()).toList();
    }
    return timedata;
  }
}

// class TimeData {
//   int? id;
//   String? actionType;
//   String? time;
//   String? date;
//   String? dateTime;
//   String? timeDifference;
//   int? userId;
//   String? createdAt;
//   String? updatedAt;
//
//   TimeData(
//       {id,
//         actionType,
//         time,
//         date,
//         dateTime,
//         timeDifference,
//         userId,
//         createdAt,
//         updatedAt});
//
//   TimeData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     actionType = json['action_type'];
//     time = json['time'];
//     date = json['date'];
//     dateTime = json['date_time'];
//     timeDifference = json['time_difference'];
//     userId = json['user_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> TimeData = new Map<String, dynamic>();
//     TimeData['id'] = id;
//     TimeData['action_type'] = actionType;
//     TimeData['time'] = time;
//     TimeData['date'] = date;
//     TimeData['date_time'] = dateTime;
//     TimeData['time_difference'] = timeDifference;
//     TimeData['user_id'] = userId;
//     TimeData['created_at'] = createdAt;
//     TimeData['updated_at'] = updatedAt;
//     return TimeData;
//   }
// }
