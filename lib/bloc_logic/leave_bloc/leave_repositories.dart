import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:oceanbit_timeclock/models/update_leave_model.dart';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_leave_model.dart';
import '../../models/user_leave_model.dart';
import '../../models/error_model.dart';
import '../../models/get_leave_by_user.dart';
import '../../models/leave_model.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class LeaveRepository {
  int page = 0;
  int totalReports = 0;
  bool isLastPage = false;
  bool isLoading = false;
  final List<LeaveData> _reportList = [];

  List<LeaveData> get reportList => _reportList;

  set reportList(List<LeaveData>? value) {
    _reportList.addAll(value!);
  }

  clearReportList() {
    _reportList.clear();
    reportList.clear();
    totalReports = 0;
    page = 1;
  }

  static Future<LeaveModel> getLeave({
    String? token,
    required int page,
    String? text,
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    final Map<String, String?> params = {
      'text': text,
      'start_date': startDate,
      'end_date': endDate,
      'leave_status_value': status,
    };

    final filteredParams = params.entries
        .where((entry) =>
            entry.value != null && entry.value!.isNotEmpty && entry.value != '')
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value!)}')
        .join('&');

    String filter = filteredParams.isNotEmpty ? '&$filteredParams' : '';

    final response = await DioClient().getRequest(
        url: '${Api.baseurl}${Api.getLeave}?page=$page&limit=20$filter',
        token: MyLocalStorage().getToken());
    Logger.println("Get Leave List :: ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = LeaveModel.fromJson(response.data);
      return responseData;
    } else {
      Logger.println("Get Leave Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.error![0].error.toString());
    }
  }

  static Future<LeaveByUserModel> getLeaveByUser({
    String? token,
    required int page,
    required int userId,
  }) async {
    final response = await DioClient().getRequest(
        url: '${Api.baseurl}${Api.getLeaveByUser}$userId?page=$page&limit=20',
        token: MyLocalStorage().getToken());
    Logger.println("Get Leave List :: ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = LeaveByUserModel.fromJson(response.data);
      return responseData;
    } else {
      Logger.println("Get Leave Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.error![0].error.toString());
    }
  }

  static Future<GetUserLeave> getUserLeave({
    String? token,
    required int page,
  }) async {
    final response = await DioClient().getRequest(
        url: '${Api.baseurl}${Api.getUserLeave}?page=$page&limit=20',
        token: MyLocalStorage().getToken());
    Logger.println("Get Leave List :: ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetUserLeave.fromJson(response.data);
      return responseData;
    } else {
      Logger.println("Get Leave Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.error![0].error.toString());
    }
  }

  static Future<AddLeaveModel> addLeave(
      {required String startDate,
      required String endDate,
      required String reason,
      required String leaveTypeValue,
      required String leaveValue,
      String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addLeave,
        token: MyLocalStorage().getToken(),
        body: {
          "start_date": startDate,
          "end_date": endDate,
          "reason": reason,
          "leave_type_value": leaveTypeValue,
          "leave_value": leaveValue,
        });
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = AddLeaveModel.fromJson(response.data);
      return responseData;
    } else {
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateLeaveModel> updateLeave({
    required int userId,
    required int leaveId,
    required int leaveStatusValue,
  }) async {
    final response = await DioClient().postRequest(
      token: MyLocalStorage().getToken(),
      body: {
        "user_id": userId,
        "leave_id": leaveId,
        "leave_status_value": leaveStatusValue,
      },
      url: '${Api.baseurl}${Api.updateLeave}',
    );
    var responseStatus = UpdateLeaveModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = UpdateLeaveModel.fromJson(response.data);
      return responseData;
    } else {
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteLeave(
      {required String id, required String leaveId}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteLeave}',
      token: MyLocalStorage().getToken(),
      body: {
        "leave_id": leaveId,
      },
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      return responseData;
    } else {
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
