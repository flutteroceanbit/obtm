import 'dart:convert';

import 'package:oceanbit_timeclock/models/update_bank_info_model.dart';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_bank_info_model.dart';
import '../../models/error_model.dart';
import '../../models/get_bank_info.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class BankInfoRepository {
  static Future<GetBankInfoModel> getBankInfo({
    String? token,
    required String id,
  }) async {
    final response = await DioClient().postMultipartRequest(
        url: '${Api.baseurl}${Api.getBankInformation}',
        token: token,
        body: {
          'id': id,
        });
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetBankInfoModel.fromJson(response.data);
      Logger.println('responseData ::: $responseData');
      return responseData;
    } else {
      Logger.println("get bank info Error ::: ${response.data}");
      var responseError = ErrorModel.fromJson(response.data);
      throw ServiceException(message: responseError.message!);
    }
  }

  static Future<AddBankInfoModel> addBankInfo(
      {required String userId,
      required String bankName,
      required String branch,
      required String accountNo,
      required String accountType,
      required String ifscCode,
      String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addBankInformation,
        token: MyLocalStorage().getToken(),
        body: {
          "user_id": userId,
          "bank_name": bankName,
          "branch": branch,
          "account_no": accountNo,
          "account_type": accountType,
          "ifsc_code": ifscCode,
        });
    var responseStatus = AddBankInfoModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = AddBankInfoModel.fromJson(response.data);
      Logger.println("Add bank info Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add bank info Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateBankInfoModel> updateBankInfo({
    required String id,
    required int userId,
    required String bankName,
    required String branch,
    required String accountNo,
    required String accountType,
    required String ifscCode,
  }) async {
    final response = await DioClient().putRequest(
        url: '${Api.baseurl}${Api.updateBankInformation}/$userId',
        token: MyLocalStorage().getToken(),
        body: {
          "user_id": userId,
          "bank_name": bankName,
          "branch": branch,
          "account_no": accountNo,
          "account_type": accountType,
          "ifsc_code": ifscCode,
        });
    var responseStatus = UpdateBankInfoModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = UpdateBankInfoModel.fromJson(response.data);
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

  static Future<SuccessModel> deleteBankInfo({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteBankInformation}/$id',
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
