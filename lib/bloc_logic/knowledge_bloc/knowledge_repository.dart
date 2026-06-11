import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:oceanbit_timeclock/models/get_knowledge_model.dart';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_knowledge_model.dart';
import '../../models/error_model.dart';
import '../../models/success_model.dart';
import '../../models/update_knowledge_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class KnowledgeRepository {
  static final KnowledgeRepository getKnowledgeRepository =
      KnowledgeRepository._();

  KnowledgeRepository._();

  factory KnowledgeRepository() {
    return getKnowledgeRepository;
  }

  final List<KnowledgeData> _data = [];

  List<KnowledgeData> get dataList => _data;

  set dataList(List<KnowledgeData>? value) {
    _data.addAll(value!);
  }

  clearReportList() {
    _data.clear();
    dataList.clear();
  }

  static Future<GetKnowledgeModel> getKnowledge({String? token}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.getKnowledge}',
      token: token,
    );
    var responseStatus = GetKnowledgeModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetKnowledgeModel.fromJson(response.data);
      Logger.println('knowledge response ::: $responseData');
      return responseData;
    } else {
      Logger.println("Knowledge Error ::: ${response.data}");
      var responseError = GetKnowledgeModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  static Future<AddKnowledgeModel> addKnowledge(
      {required int userId,
      required String title,
      required String link,
      required String desc,
      required String language,
      String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addKnowledge,
        token: MyLocalStorage().getToken(),
        body: {
          "user_id": userId.toString(),
          "title": title,
          "link": link,
          "description": desc,
          "language": language,
        });
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = AddKnowledgeModel.fromJson(response.data);
      Logger.println("Add Knowledge Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add Knowledge Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateKnowledgeModel> updateKnowledge({
    required String id,
    required String title,
    required String link,
    required String desc,
    required String language,
  }) async {
    final response = await DioClient().postRequest(
      token: MyLocalStorage().getToken(),
      body: {
        "title": title,
        "link": link,
        "description": desc,
        "language": language,
      },
      url: '${Api.baseurl}${Api.updateKnowledge}/$id',
    );
    Logger.println("Knowledge data response : ${response.data}");
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = UpdateKnowledgeModel.fromJson(response.data);
      Logger.println("update Knowledge Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("update Knowledge Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteKnowledge({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteKnowledge}/$id',
      token: MyLocalStorage().getToken(),
    );
    Logger.println("Knowledge data response : ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete Knowledge Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete Knowledge Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
