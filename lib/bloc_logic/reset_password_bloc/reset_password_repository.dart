import 'dart:convert';
import 'package:oceanbit_timeclock/models/success_model.dart';
import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../models/reset_password_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class ResetPassword {
  static Future<ResetPasswordModel> resetPassword(
      {required int id, String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.resetPassword,
        token: MyLocalStorage().getToken(),
        body: {
          "id": id.toString(),
        });
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = ResetPasswordModel.fromJson(response.data);
      Logger.println("resetPassword :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("resetPassword :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
