import 'dart:convert';
import 'package:oceanbit_timeclock/models/success_model.dart';
import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_holiday_model.dart';
import '../../models/error_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class AddHoliday {
  static Future<AddHolidayModel> addHoliday(
      {required int holidayTypeId,
      required String startDate,
      required String endDate,
      required String desc,
      String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addHoliday,
        token: MyLocalStorage().getToken(),
        body: {
          "holiday_type_id": holidayTypeId.toString(),
          "start_date": startDate,
          "end_date": endDate,
          "description": desc,
        });
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = AddHolidayModel.fromJson(response.data);
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
