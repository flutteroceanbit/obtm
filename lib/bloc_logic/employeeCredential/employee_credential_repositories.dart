import 'dart:convert';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_employee_credential_model.dart';
import '../../models/error_model.dart';
import '../../models/get_employee_credential_model.dart';
import '../../models/success_model.dart';
import '../../models/update_employee_creadential.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class EmployeeCredentialRepository {
  static Future<GetEmployeeCredentials> getEmployeeCredential(
      {String? token, required String id}) async {
    final response = await DioClient().postMultipartRequest(
        url: '${Api.baseurl}${Api.getEmployeeCredential}',
        token: token,
        body: {
          "id": id,
        });
    var responseStatus = GetEmployeeCredentials.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetEmployeeCredentials.fromJson(response.data);
      Logger.println('responseData ::: $responseData');
      return responseData;
    } else {
      Logger.println("get bank info Error ::: ${response.data}");
      var responseError = ErrorModel.fromJson(response.data);
      throw ServiceException(message: responseError.message!);
    }
  }

  static Future<AddEmployeeCredentials> addEmployeeCredential(
      {required String userId,
      required String name,
      required String email,
      required String emailPassword,
      required String skypeName,
      required String skypePassword,
      String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addEmployeeCredential,
        token: MyLocalStorage().getToken(),
        body: {
          "user_id": userId,
          "name": name,
          "email": email,
          "email_password": emailPassword,
          "skype_name": skypeName,
          "skype_password": skypePassword,
        });
    var responseStatus = AddEmployeeCredentials.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = AddEmployeeCredentials.fromJson(response.data);
      Logger.println("Add credential Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add credetial Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateEmployeeCredentials> updateEmployeeCredential({
    required String id,
    required int userId,
    required String name,
    required String email,
    required String emailPassword,
    required String skypeName,
    required String skypePassword,
  }) async {
    final response = await DioClient().putRequest(
        token: MyLocalStorage().getToken(),
        body: {
          "name": name,
          "email": email,
          "email_password": emailPassword,
          "skype_name": skypeName,
          "skype_password": skypePassword,
        },
        url: '${Api.baseurl}${Api.updateEmployeeCredential}/$userId');
    var responseStatus = UpdateEmployeeCredentials.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = UpdateEmployeeCredentials.fromJson(response.data);
      Logger.println("update credential:::: $responseData");
      return responseData;
    } else {
      Logger.println("update credential Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteEmployeeCredential(
      {required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteEmployeeCredential}/$id',
      token: MyLocalStorage().getToken(),
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete credential Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete credential Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
