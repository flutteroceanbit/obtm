import 'dart:convert';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_previous_employer.dart';
import '../../models/error_model.dart';
import '../../models/get_previous_employer_model.dart';
import '../../models/success_model.dart';
import '../../models/update_previous_emaployer.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class PreviousEmployerRepository {
  static Future<GetPreviousEmployerModel> getPreviousEmployer({
    String? token,
    required String id,
  }) async {
    final response = await DioClient().postMultipartRequest(
        url: '${Api.baseurl}${Api.getPreviousEmployer}',
        token: token,
        body: {
          "id": id,
        });
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetPreviousEmployerModel.fromJson(response.data);
      Logger.println('responseData ::: $responseData');
      return responseData;
    } else {
      Logger.println("Error ::: ${response.data}");
      var responseError = ErrorModel.fromJson(response.data);
      throw ServiceException(message: responseError.message!);
    }
  }

  static Future<AddPreviousEmployerModel> addPreviousEmployer(
      {required String userId,
      required String companyName,
      required String profileDesignation,
      required String salaryPerYear,
      required String companyMail,
      required String companyWebsite,
      required String companyContactNo,
      String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addPreviousEmployer,
        token: MyLocalStorage().getToken(),
        body: {
          "user_id": userId,
          "company_name": companyName,
          "profile_designation": profileDesignation,
          "salary_per_year": salaryPerYear,
          "company_mail": companyMail,
          "company_website": companyWebsite,
          "company_contact_no": companyContactNo,
        });
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = AddPreviousEmployerModel.fromJson(response.data);
      return responseData;
    } else {
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdatePreviousEmployerModel> updatePreviousEmployer({
    required String id,
    required int userId,
    required String companyName,
    required String profileDesignation,
    required String salaryPerYear,
    required String companyMail,
    required String companyWebsite,
    required String companyContactNo,
  }) async {
    final response = await DioClient().putRequest(
        url: '${Api.baseurl}${Api.updatePreviousEmployer}/$userId',
        token: MyLocalStorage().getToken(),
        body: {
          "company_name": companyName,
          "profile_designation": profileDesignation,
          "salary_per_year": salaryPerYear,
          "company_mail": companyMail,
          "company_website": companyWebsite,
          "company_contact_no": companyContactNo,
        });
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = UpdatePreviousEmployerModel.fromJson(response.data);
      Logger.println("update bank info :::: $responseData");
      return responseData;
    } else {
      Logger.println("update bank info Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deletePreviousEmployer(
      {required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deletePreviousEmployer}/$id',
      token: MyLocalStorage().getToken(),
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete bank info Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete bank info Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
