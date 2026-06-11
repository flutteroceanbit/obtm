import 'dart:convert';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_Department_model.dart';
import '../../models/error_model.dart';
import '../../models/get_department_model.dart';
import '../../models/success_model.dart';
import '../../models/update_Department_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class DepartmentRepository {
  static final DepartmentRepository getDepartmentRepository =
      DepartmentRepository._();

  DepartmentRepository._();

  factory DepartmentRepository() {
    return getDepartmentRepository;
  }

  final List<DepartmentData> _data = [];

  List<DepartmentData> get dataList => _data;

  set dataList(List<DepartmentData>? value) {
    _data.addAll(value!);
  }

  clearReportList() {
    _data.clear();
    dataList.clear();
  }

  static Future<GetDepartmentModel> getDepartment({String? token}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.getDepartment}',
      token: token,
    );
    var responseStatus = GetDepartmentModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetDepartmentModel.fromJson(response.data);
      Logger.println('Department response ::: $responseData');
      return responseData;
    } else {
      Logger.println("Department Error ::: ${response.data}");
      var responseError = GetDepartmentModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  static Future<AddDepartmentModel> addDepartment(
      {required String name, String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addDepartment,
        token: MyLocalStorage().getToken(),
        body: {
          "name": name,
        });
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = AddDepartmentModel.fromJson(response.data);
      Logger.println("Add Department Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add Department Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateDepartmentModel> updateDepartment({
    required String id,
    required String name,
  }) async {
    final response = await DioClient().postRequest(
      token: MyLocalStorage().getToken(),
      body: {
        "name": name,
      },
      url: '${Api.baseurl}${Api.updateDepartment}/$id',
    );
    Logger.println("Department data response : ${response.data}");
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = UpdateDepartmentModel.fromJson(response.data);
      Logger.println("update Department Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("update Department Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteDepartment({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteDepartment}/$id',
      token: MyLocalStorage().getToken(),
    );
    Logger.println("Department data response : ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete Department Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete Department Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
