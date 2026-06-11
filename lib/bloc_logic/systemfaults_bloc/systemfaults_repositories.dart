import 'dart:convert';
import 'package:dio/dio.dart';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_system_fault_model.dart';
import '../../models/get_admin_system_fault_model.dart';
import '../../models/get_system_fault_model.dart';
import '../../models/update_admin_system_fault_model.dart';
import '../../models/update_system_fault_model.dart';
import '../../models/error_model.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class SystemFaultsRepository {
  static Future<GetSystemFaultModel> getSystemFaults({
    String? token,
  }) async {
    final response = await DioClient().getRequest(
        url: '${Api.baseurl}${Api.getFault}',
        token: MyLocalStorage().getToken());
    Logger.println("Get SystemFaults List :: ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetSystemFaultModel.fromJson(response.data);
      return responseData;
    } else {
      Logger.println("Get SystemFaults Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.error![0].error.toString());
    }
  }

  GetAdminSystemFaultModel? systemFaultsData;

  GetAdminSystemFaultModel? get systemFaultsDataList => systemFaultsData;

  set systemFaultsDataList(GetAdminSystemFaultModel? value) {
    systemFaultsData = value;
  }

  byUserClearReportList() {
    systemFaultsData = null;
    systemFaultsDataList = null;
  }

  static Future<GetAdminSystemFaultModel> adminSystemFaultsByUser({
    String? token,
  }) async {
    final response = await DioClient().getRequest(
        url: '${Api.baseurl}${Api.getAdminFault}',
        token: MyLocalStorage().getToken());
    Logger.println("Get SystemFaults List :: ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetAdminSystemFaultModel.fromJson(response.data);
      return responseData;
    } else {
      Logger.println("Get SystemFaults Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.error![0].error.toString());
    }
  }

  static Future<AddSystemFaultModel> addSystemFaults(
      {required String systemType,
      required String description,
      String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addFault,
        token: MyLocalStorage().getToken(),
        body: {
          "system_type": systemType,
          "description": description,
        });
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = AddSystemFaultModel.fromJson(response.data);
      return responseData;
    } else {
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateSystemFaultModel> updateSystemFaults({
    required int id,
    required String systemType,
    required String description,
  }) async {
    final response = await DioClient().postRequest(
      token: MyLocalStorage().getToken(),
      body: {
        "system_type": systemType,
        "description": description,
      },
      url: '${Api.baseurl}${Api.updateFault}/$id',
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = UpdateSystemFaultModel.fromJson(response.data);
      return responseData;
    } else {
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateAdminSystemFaultModel> updateAdminSystemFaults({
    required int id,
    required String status,
  }) async {
    final response = await DioClient().putRequest(
      url: '${Api.baseurl}${Api.updateAdminFault}/$id',
      token: MyLocalStorage().getToken(),
      body: {
        "status": status,
      },
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = UpdateAdminSystemFaultModel.fromJson(response.data);
      return responseData;
    } else {
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteSystemFaults({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteFault}/$id',
      token: MyLocalStorage().getToken(),
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
