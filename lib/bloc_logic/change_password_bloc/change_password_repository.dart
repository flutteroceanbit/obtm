import 'dart:core';
import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../utils/exceptions/service_exception.dart';

class ChangePasswordRepository {
  static Future<bool> changePassword(
      {required String? currentPassword,
      required String? newPassword,
      required String? confirmPassword,
      String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.changePassword,
        token: MyLocalStorage().getToken(),
        body: {
          "old_password": currentPassword!,
          "new_password": newPassword!,
          "new_password_confirmation": confirmPassword!,
        });
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      return responseStatus['status'];
    } else {
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
