import 'dart:convert';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../models/holiday_type_model.dart';
import '../../models/success_model.dart';
import '../../models/update_holiday_type_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class GetHolidayTypeRepository {
  static final GetHolidayTypeRepository getHolidayRepository =
      GetHolidayTypeRepository._();

  GetHolidayTypeRepository._();

  factory GetHolidayTypeRepository() {
    return getHolidayRepository;
  }

  final List<Data> _data = [];

  List<Data> get dataList => _data;

  set dataList(List<Data>? value) {
    _data.addAll(value!);
  }

  clearReportList() {
    _data.clear();
    dataList.clear();
  }

  static Future<HolidayTypeModel> getHoliday({String? token}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.allHolidaysType}',
      token: token,
    );
    var responseStatus = HolidayTypeModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = HolidayTypeModel.fromJson(response.data);
      Logger.println('responseData ::: $responseData');
      return responseData;
    } else {
      Logger.println("Holiday Error ::: ${response.data}");
      var responseError = HolidayTypeModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  static Future<UpdateHolidayTypeModel> updateHolidayType(
      {required String id, required String name, required bool isMulti}) async {
    final response = await DioClient().putRequest(
        url: '${Api.baseurl}${Api.updateHolidayType}/$id',
        token: MyLocalStorage().getToken(),
        body: {
          "name": name,
          "is_multi": isMulti ? '1' : '0',
        });
    Logger.println("holiday data response : ${response.data}");
    var responseStatus = UpdateHolidayTypeModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = UpdateHolidayTypeModel.fromJson(response.data);
      Logger.println("update holiday Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("update holiday Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteHolidayType({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteHolidayType}/$id',
      token: MyLocalStorage().getToken(),
    );
    Logger.println("holiday data response : ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete holiday Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete holiday Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
