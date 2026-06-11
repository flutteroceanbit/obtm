import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../models/birthday_of_month_model.dart';
import '../../models/error_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class BirthdayListRepository {
  static Future<BirthdayOfMonthModel> getUsersBirthday(
      {String? token, required String currentMonth}) async {
    Logger.println("UserDetailRepository : id: $token");
    final response = await DioClient().getRequest(
        url: Api.baseurl + Api.usersBirthday + currentMonth, token: token);
    var responseStatus = BirthdayOfMonthModel.fromJson(response.data);
    Logger.println(
        "Response from user birthday detail :: ${responseStatus.status}");
    if (responseStatus.status == true) {
      var responseData = BirthdayOfMonthModel.fromJson(response.data);
      return responseData;
    } else {
      var responseData = ErrorModel.fromJson(response.data);
      Logger.println("User Detail List Error :::: ${responseData.error!}");
      throw ServiceException(
          message: responseData
              .message! /*=='Request Failed' ? responseData.error![0].error.toString() : responseStatus.message!*/);
    }
  }
}
