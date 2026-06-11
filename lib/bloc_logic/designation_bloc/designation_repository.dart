import 'dart:convert';

import 'package:oceanbit_timeclock/http/api_client.dart';

import '../../constant/api.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_designation_model.dart';
import '../../models/error_model.dart';
import '../../models/get_designation_model.dart';
import '../../models/success_model.dart';
import '../../models/update_designation_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class DesignationRepository {
  static final DesignationRepository getDesignationRepository =
      DesignationRepository._();

  DesignationRepository._();

  factory DesignationRepository() {
    return getDesignationRepository;
  }

  final List<DesignationData> _data = [];

  List<DesignationData> get dataList => _data;

  set dataList(List<DesignationData>? value) {
    _data.addAll(value!);
  }

  clearReportList() {
    _data.clear();
    dataList.clear();
  }

  static Future<GetDesignationModel> getDesignation({String? token}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.getDesignation}',
      token: token,
    );
    var responseStatus = GetDesignationModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetDesignationModel.fromJson(response.data);
      Logger.println('Designation response ::: $responseData');
      return responseData;
    } else {
      Logger.println("Designation Error ::: ${response.data}");
      var responseError = GetDesignationModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  static Future<AddDesignationModel> addDesignation(
      {required String name, required String shortName, String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addDesignation,
        token: MyLocalStorage().getToken(),
        body: {
          "name": name,
          "short_name": shortName,
        });
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = AddDesignationModel.fromJson(response.data);
      Logger.println("Add Designation Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add Designation Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateDesignationModel> updateDesignation({
    required String id,
    required String name,
    required String shortName,
  }) async {
    final response = await DioClient().postRequest(
      token: MyLocalStorage().getToken(),
      body: {
        "name": name,
        "short_name": shortName,
      },
      url: '${Api.baseurl}${Api.updateDesignation}/$id',
    );
    Logger.println("Designation data response : ${response.data}");
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = UpdateDesignationModel.fromJson(response.data);
      Logger.println("update Designation Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("update Designation Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteDesignation({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteDesignation}/$id',
      token: MyLocalStorage().getToken(),
    );
    Logger.println("Designation data response : ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete Designation Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete Designation Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
