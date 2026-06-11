import 'dart:convert';
import 'package:oceanbit_timeclock/models/success_model.dart';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../models/add_update_contact_model.dart';
import '../../models/error_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class AddUpdateContactDetailRepository {
  static Future<AddUpdateContactDetailModel> getAddUpdatePersonalDetail({
    String? token,
    required int id,
    required String email,
    required String permanentAddress,
    required String correspondenceAddress,
    required String parentsPhone,
  }) async {
    Logger.println("AddUpdateContactDetailRepository");
    final response = await DioClient().postRequest(
        url: Api.baseurl + Api.addUpdateContactDetail,
        body: {
          "id": id.toString(),
          "email": email.toString(),
          "parents_phone": parentsPhone.toString(),
          "permanent_address": permanentAddress.toString(),
          "correspondence_address": correspondenceAddress.toString(),
        },
        token: token);
    var responseStatus = response.data;
    Logger.println(
        "Response from add update contact detail :: ${responseStatus['status']}");
    if (responseStatus['status'] == true) {
      var responseData = AddUpdateContactDetailModel.fromJson(response.data);
      return responseData;
    } else {
      var responseData = ErrorModel.fromJson(response.data);
      Logger.println(
          "Contact Detail List Error :::: ${responseData.error![0].error}");
      throw ServiceException(
          message: responseData.message == 'Request Failed'
              ? responseData.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
