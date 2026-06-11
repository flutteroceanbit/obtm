import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:oceanbit_timeclock/models/add_transport_model.dart';
import 'package:oceanbit_timeclock/models/get_transport_model.dart';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../models/get_bank_info.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class TransportRepository {
  static Future<GetTransportModel> getTransport(
      {String? token, required String userId}) async {
    final response = await DioClient().postMultipartRequest(
        url: '${Api.baseurl}${Api.getTransport}',
        token: token,
        body: {
          'user_id': userId,
        });
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetTransportModel.fromJson(response.data);
      Logger.println('responseData ::: $responseData');
      return responseData;
    } else {
      Logger.println("get transport Error ::: ${response.data}");
      var responseError = ErrorModel.fromJson(response.data);
      throw ServiceException(message: responseError.message!);
    }
  }

  static Future<AddTransportModel> addTransport(
      {required String transportName,
      required String transportNumber,
      required String filePath,
      required PlatformFile file,
      required String userId,
      String? token}) async {
    final response = await DioClient().postMultiPart(
        url: Api.baseurl + Api.addTransport,
        token: MyLocalStorage().getToken(),
        filePath: filePath,
        file: file,
        fileKey: 'rc_book',
        body: {
          'transport_name': transportName,
          'transport_number': transportNumber,
          'user_id': userId,
        });
    Logger.println('jsonDecode(response.body) :: ${response.data}');
    var responseStatus = AddTransportModel.fromJson(response.data);
    Logger.println('status ::${responseStatus.status}');
    if (responseStatus.status == true) {
      var responseData = AddTransportModel.fromJson(response.data);
      Logger.println("Add transport Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add transport Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteTransport({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteTransport}/$id',
      token: MyLocalStorage().getToken(),
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete transport Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete transport Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
