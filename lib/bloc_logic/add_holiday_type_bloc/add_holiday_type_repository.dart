import 'dart:convert';
import 'package:oceanbit_timeclock/models/add_holiday_type_model.dart';
import 'package:oceanbit_timeclock/models/success_model.dart';
import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class AddHolidayType {
  static Future<AddHolidayTypeModel> addHolidayType(
      {required String name, required bool isMulti, String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addHolidayType,
        token: MyLocalStorage().getToken(),
        body: {"name": name, "is_multi": isMulti ? '1' : '0'});
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = AddHolidayTypeModel.fromJson(response.data);
      Logger.println("Add holiday Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add holiday Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
