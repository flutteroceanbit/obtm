import 'dart:convert';
import 'package:oceanbit_timeclock/models/error_model.dart';
import 'package:oceanbit_timeclock/models/user_detail_model.dart';
import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class UserDetailRepository {
  static Future<UserDetailModel> getUserDetail(
      {String? token, required String id}) async {
    Logger.println("UserDetailRepository : id: $id");
    final response = await DioClient().getRequest(
        url: '${Api.baseurl}${Api.userDetail}?id=$id', token: token);
    var responseStatus = UserDetailModel.fromJson(response.data);
    Logger.println("Response from user detail :: ${responseStatus.status}");
    if (responseStatus.status == true) {
      var responseData = UserDetailModel.fromJson(response.data);
      return responseData;
    } else {
      var responseData = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseData.message == 'Request Failed'
              ? responseData.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UserDetailModel> getUserProfile({String? token}) async {
    Logger.println("UserDetailRepository : id: $token");
    final response = await DioClient()
        .getRequest(url: Api.baseurl + Api.userProfile, token: token);
    var responseStatus = UserDetailModel.fromJson(response.data);
    Logger.println("Response from user detail :: ${responseStatus.status}");
    if (responseStatus.status == true) {
      var responseData = UserDetailModel.fromJson(response.data);
      return responseData;
    } else {
      var responseData = ErrorModel.fromJson(response.data);
      Logger.println(
          "User Detail List Error :::: ${responseData.error![0].error}");
      throw ServiceException(
          message: responseData.message == 'Request Failed'
              ? responseData.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
