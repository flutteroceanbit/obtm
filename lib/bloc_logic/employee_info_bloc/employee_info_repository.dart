import 'dart:convert';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_employee_info_model.dart';
import '../../models/employee_ifo_detail_model.dart';
import '../../models/error_model.dart';
import '../../models/get_employee_info_model.dart';
import '../../models/increment_model.dart';
import '../../models/success_model.dart';
import '../../models/update_employee_info_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class EmployeeInfoRepository {
  static final EmployeeInfoRepository getEmployeeInfoRepository =
      EmployeeInfoRepository._();

  EmployeeInfoRepository._();

  factory EmployeeInfoRepository() {
    return getEmployeeInfoRepository;
  }

  final List<EmployeeInfoData> _data = [];

  List<EmployeeInfoData> get dataList => _data;

  set dataList(List<EmployeeInfoData>? value) {
    _data.addAll(value!);
  }

  clearReportList() {
    _data.clear();
    dataList.clear();
  }

  static Future<GetEmployeeInfoModel> getEmployeeInfo(
      {String? token, required String userId}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.getEmployeeInfo}/$userId',
      token: token,
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetEmployeeInfoModel.fromJson(response.data);
      Logger.println('EmployeeInfo response ::: $responseData');
      return responseData;
    } else {
      Logger.println("EmployeeInfo Error ::: ${response.data}");
      var responseError = GetEmployeeInfoModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  static Future<GetEmployeeInfoDetailModel> getEmployeeInfoDetail(
      {String? token}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.getEmployeeInfoDetail}',
      token: token,
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetEmployeeInfoDetailModel.fromJson(response.data);
      Logger.println('EmployeeInfo response ::: $responseData');
      return responseData;
    } else {
      Logger.println("EmployeeInfo Error ::: ${response.data}");
      var responseError = GetEmployeeInfoDetailModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  static Future<AddEmployeeInfoModel> addEmployeeInfo(
      {required int userId,
      required String departmentId,
      required String designationId,
      required String period,
      required String basicSalary,
      required String startDate,
      required String hra,
      required String da,
      required String ta,
      required String securityDeposit,
      required String monthlySecurityDeposit,
      required String bonusOne,
      required String bonusTwo,
      required String minimumFullTime,
      required String minimumHalfTime,
      String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addEmployeeInfo,
        token: MyLocalStorage().getToken(),
        body: {
          "user_id": userId.toString(),
          "department_id": departmentId,
          "designation_id": designationId,
          "period": period,
          "basic_salary": basicSalary,
          "start_date": startDate,
          "HRA": hra,
          "DA": da,
          "TA": ta,
          "security_deposit": securityDeposit,
          "monthly_security_deposit": monthlySecurityDeposit,
          "bonus_one": bonusOne,
          "bonus_two": bonusTwo,
          "minimum_full_time": minimumFullTime,
          "minimum_half_time": minimumHalfTime,
        });
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = AddEmployeeInfoModel.fromJson(response.data);
      Logger.println("Add EmployeeInfo Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add EmployeeInfo Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<IncrementModel> increment(
      {required int userId,
      required String departmentId,
      required String designationId,
      required String securityDeposit,
      required String monthlySecurityDeposit,
      required String basicSalary,
      required String period,
      required String bonusOne,
      required String bonusTwo,
      required String startDate,
      required String hra,
      required String da,
      required String ta,
      required String minimumFullTime,
      required String minimumHalfTime,
      String? token}) async {
    Logger.println('this is increment api ');
    final response = await DioClient().postMultipartRequest(
        url: '${Api.baseurl}${Api.incrementApi}/$userId',
        token: MyLocalStorage().getToken(),
        body: {
          "department_id": departmentId,
          "designation_id": designationId,
          "basic_salary": basicSalary,
          "start_date": startDate,
          "HRA": hra,
          "DA": da,
          "TA": ta,
          "security_deposit": securityDeposit,
          "monthly_security_deposit": monthlySecurityDeposit,
          "bonus_one": bonusOne,
          "bonus_two": bonusTwo,
          "minimum_full_time": minimumFullTime,
          "minimum_half_time": minimumHalfTime,
        });
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = IncrementModel.fromJson(response.data);
      Logger.println("Increment Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Increment Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateEmployeeInfoModel> updateEmployeeInfo({
    required int userId,
    required String departmentId,
    required String designationId,
    required String period,
    required String basicSalary,
    required String startDate,
    required String hra,
    required String da,
    required String ta,
    required String securityDeposit,
    required String monthlySecurityDeposit,
    required String bonusOne,
    required String bonusTwo,
    required String minimumFullTime,
    required String minimumHalfTime,
  }) async {
    final response = await DioClient().postRequest(
      token: MyLocalStorage().getToken(),
      body: {
        "department_id": departmentId,
        "designation_id": designationId,
        "period": period,
        "basic_salary": basicSalary,
        "start_date": startDate,
        "HRA": hra,
        "DA": da,
        "TA": ta,
        "security_deposit": securityDeposit,
        "monthly_security_deposit": monthlySecurityDeposit,
        "bonus_one": bonusOne,
        "bonus_two": bonusTwo,
        "minimum_full_time": minimumFullTime,
        "minimum_half_time": minimumHalfTime,
      },
      url: '${Api.baseurl}${Api.updateEmployeeInfo}/$userId',
    );
    Logger.println("EmployeeInfo data response : ${response.data}");
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = UpdateEmployeeInfoModel.fromJson(response.data);
      Logger.println("update EmployeeInfo Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("update EmployeeInfo Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteEmployeeInfo({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteEmployeeInfo}/$id',
      token: MyLocalStorage().getToken(),
    );
    Logger.println("EmployeeInfo data response : ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete EmployeeInfo Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete EmployeeInfo Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
