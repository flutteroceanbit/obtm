import 'dart:convert';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../models/quotes/add_quotes_model.dart';
import '../../models/quotes/get_quotes_model.dart';
import '../../models/quotes/update_quotes_model.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class QuoteRepository {
  static final QuoteRepository getQuoteRepository = QuoteRepository._();

  QuoteRepository._();

  factory QuoteRepository() {
    return getQuoteRepository;
  }

  final List<QuoteData> _data = [];

  List<QuoteData> get dataList => _data;

  set dataList(List<QuoteData>? value) {
    _data.addAll(value!);
  }

  clearReportList() {
    _data.clear();
    dataList.clear();
  }

  static Future<GetQuoteModel> getQuote({String? token}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.getQuote}',
      token: token,
    );
    var responseStatus = GetQuoteModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetQuoteModel.fromJson(response.data);
      Logger.println('Quote response ::: $responseData');
      return responseData;
    } else {
      Logger.println("Quote Error ::: ${response.data}");
      var responseError = GetQuoteModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  static Future<AddQuoteModel> addQuote(
      {required String quotes, String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addQuote,
        token: MyLocalStorage().getToken(),
        body: {
          "quotes": quotes,
        });
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = AddQuoteModel.fromJson(response.data);
      Logger.println("Add Quote Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add Quote Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateQuoteModel> updateQuote({
    required String id,
    required String quotes,
  }) async {
    final response = await DioClient().postRequest(
      token: MyLocalStorage().getToken(),
      body: {
        "quotes": quotes,
      },
      url: '${Api.baseurl}${Api.updateQuote}/$id',
    );
    Logger.println("Quote data response : ${response.data}");
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = UpdateQuoteModel.fromJson(response.data);
      Logger.println("update Quote Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("update Quote Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteQuote({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteQuote}/$id',
      token: MyLocalStorage().getToken(),
    );
    Logger.println("Quote data response : ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete Quote Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete Quote Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
