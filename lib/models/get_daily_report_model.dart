class GetDailyReportModel {
  bool? status;
  String? message;
  List<ReportData>? data;
  int? currentPage;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  dynamic perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  GetDailyReportModel(
      {status,
      message,
      currentPage,
      data,
      firstPageUrl,
      from,
      lastPage,
      lastPageUrl,
      nextPageUrl,
      path,
      perPage,
      prevPageUrl,
      to,
      total});

  GetDailyReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ReportData>[];
      json['data'].forEach((v) {
        data!.add(ReportData.fromJson(v));
      });
      firstPageUrl = json['first_page_url'];
      from = json['from'];
      lastPage = json['last_page'];
      lastPageUrl = json['last_page_url'];
      nextPageUrl = json['next_page_url'];
      path = json['path'];
      perPage = json['per_page'];
      prevPageUrl = json['prev_page_url'];
      to = json['to'];
      total = json['total'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['current_page'] = currentPage;
    data['data'] = this.data!.map((v) => v.toJson()).toList();
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class ReportData {
  int? id;
  String? date;
  String? totalTime;
  String? intermediateTime;
  String? reportText;
  int? userId;
  String? createdAt;
  String? updatedAt;

  ReportData(
      {id,
      date,
      totalTime,
      reportText,
      userId,
      createdAt,
      updatedAt,
      intermediateTime});

  ReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    totalTime = json['total_time'];
    intermediateTime = json['intermediate_Time'];
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
