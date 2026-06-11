import 'dart:convert';

import 'package:oceanbit_timeclock/http/api_client.dart';
import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
import 'package:oceanbit_timeclock/models/success_model.dart';
import 'package:oceanbit_timeclock/utils/logger.dart';

import '../../constant/api.dart';
import '../../models/user_list_model.dart';
import '../../utils/exceptions/service_exception.dart';

class UserListRepository {
  static Future<UserListModel> getUserList({String? token}) async {
    final response = await DioClient().getRequest(
        url: Api.baseurl + Api.userList, token: MyLocalStorage().getToken());
    Logger.println('User List Response ::: $response');
    var responseStatus = UserListModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = UserListModel.fromJson(response.data);
      return responseData;
    } else {
      var responseStatus = SuccessModel.fromJson(response.data);
      Logger.println("User List Error :::: ${responseStatus.error!}");
      throw ServiceException(message: responseStatus.error!);
    }
  }
}
