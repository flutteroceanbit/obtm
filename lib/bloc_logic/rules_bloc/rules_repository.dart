import 'dart:convert';
import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../models/rules/add_rules_model.dart';
import '../../models/rules/get_rules_model.dart';
import '../../models/rules/update_rules_model.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class RulesRepository {
  static final RulesRepository getRulesRepository = RulesRepository._();

  RulesRepository._();

  factory RulesRepository() {
    return getRulesRepository;
  }

  final List<RulesData> _data = [];

  List<RulesData> get dataList => _data;

  set dataList(List<RulesData>? value) {
    _data.addAll(value!);
  }

  clearReportList() {
    _data.clear();
    dataList.clear();
  }

  static Future<GetRulesModel> getRules({String? token}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.getRules}',
      token: token,
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetRulesModel.fromJson(response.data);
      Logger.println('responseData ::: $responseData');
      return responseData;
    } else {
      Logger.println("Rules Error ::: ${response.data}");
      var responseError = GetRulesModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  static Future<AddRulesModel> addRules(
      {required String rule, String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addRules,
        token: MyLocalStorage().getToken(),
        body: {"rule": rule});
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = AddRulesModel.fromJson(response.data);
      Logger.println("Add Rules Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add Rules Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateRulesModel> updateRules({
    required String id,
    required String rule,
  }) async {
    final response = await DioClient().postRequest(
      token: MyLocalStorage().getToken(),
      body: {
        "rule": rule,
      },
      url: '${Api.baseurl}${Api.updateRules}/$id',
    );
    Logger.println("Rules data response : ${response.data}");
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = UpdateRulesModel.fromJson(response.data);
      Logger.println("update Rules Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("update Rules Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteRules({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteRules}/$id',
      token: MyLocalStorage().getToken(),
    );
    Logger.println("Rules data response : ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete Rules Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete Rules Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
