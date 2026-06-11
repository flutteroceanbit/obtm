class AddLocalTimeSlotModel {
  bool? status;
  String? message;
  List<TimeSlot>? timeSlot;

  AddLocalTimeSlotModel({this.status, this.message, this.timeSlot});

  AddLocalTimeSlotModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      timeSlot = <TimeSlot>[];
      json['data'].forEach((v) {
        timeSlot!.add(TimeSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (timeSlot != null) {
      data['data'] = timeSlot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSlot {
  String? id;
  String? actionType;
  String? date;
  String? dateTime;
  String? time;
  String? timeDifference;

  TimeSlot({
    this.id,
    this.actionType,
    this.date,
    this.dateTime,
    this.time,
    this.timeDifference,
  });

  TimeSlot.fromJson(Map<String, String> json) {
    id = json['id'];
    actionType = json['action_type'];
    date = json['date'];
    dateTime = json['date_time'];
    time = json['time'];
    timeDifference = json['time_difference'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['id'] = id!;
    data['action_type'] = actionType!;
    data['date'] = date!;
    data['date_time'] = dateTime!;
    data['time'] = time!;
    data['time_difference'] = timeDifference!;
    return data;
  }
}
/*
class AddLocalTimeSlotModel {
  */
/*String? id;
  String? actionType;
  String? date;
  String? dateTime;
  String? time;
  String? timeDifference;

  AddLocalTimeSlotModel(
      {this.id,
        this.actionType,
        this.date,
        this.dateTime,
        this.time,
        this.timeDifference
      });

  AddLocalTimeSlotModel.fromJson(Map<String, String> json) {
    id = json['id'];
    actionType = json['action_type'];
    date = json['date'];
    dateTime = json['date_time'];
    time = json['time'];
    timeDifference = json['time_difference'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['id'] = id!;
    data['action_type'] = actionType!;
    data['date'] = date!;
    data['date_time'] = dateTime!;
    data['time'] = time!;
    data['time_difference'] = timeDifference!;
    return data;
  }*/ /*

}*/
