import 'dart:convert';
import 'package:oceanbit_timeclock/http/api_client.dart';
import '../../constant/api.dart';
import '../../models/auth_model.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class RegisterRepository {
  static Future<AuthModel> register(
      {String? firstName,
      String? lastName,
      String? email,
      String? phone,
      String? password,
      String? confirmPassword}) async {
    final response = await DioClient().postMultipartRequest(
      url: Api.baseurl + Api.register,
      body: {
        'first_name': firstName!,
        'last_name': lastName!,
        'email': email!,
        'phone': phone!,
        'password': password!,
        'confirm_password': confirmPassword!
      },
    );

    Logger.println('register response = ${response.data}');
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = AuthModel.fromJson(response.data);
      return responseData;
    } else {
      /*  var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.error ??
          errorBody.errors?.userEmail ??
          errorBody.errors?.userType ??
          errorBody.errors?.plainPassword ??
          Strings.error_failed_login;*/
      // var responseData = ErrorModel.fromJson(jsonDecode(response.body));
      // print('login error=${responseData.error!}');
      throw ServiceException(message: responseStatus.error!);
    }
  }
}
