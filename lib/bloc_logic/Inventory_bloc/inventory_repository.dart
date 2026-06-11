import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:oceanbit_timeclock/models/get_inventory_model.dart';

import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_inventory_model.dart';
import '../../models/get_inventory_by_id_model.dart';
import '../../models/update_inventory_model.dart';
import '../../models/error_model.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class InventoryRepository {
  static final InventoryRepository getInventoryRepository =
      InventoryRepository._();

  InventoryRepository._();

  factory InventoryRepository() {
    return getInventoryRepository;
  }

  final List<InventoryData> _data = [];

  List<InventoryData> get dataList => _data;

  set dataList(List<InventoryData>? value) {
    _data.addAll(value!);
  }

  clearReportList() {
    _data.clear();
    dataList.clear();
  }

  static Future<GetInventoryModel> getInventory({String? token}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.getInventory}',
      token: token,
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetInventoryModel.fromJson(response.data);
      Logger.println('responseData ::: $responseData');
      return responseData;
    } else {
      Logger.println("Inventory Error ::: ${response.data}");
      var responseError = GetInventoryModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  static Future<GetInventoryByIdModel> getInventoryById(
      {String? token, required int id}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.getInventory}/$id',
      token: token,
    );
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetInventoryByIdModel.fromJson(response.data);
      Logger.println('responseData ::: $responseData');
      return responseData;
    } else {
      Logger.println("Inventory Error ::: ${response.data}");
      var responseError = GetInventoryModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  static Future<AddInventoryModel> addInventory(
      {required String inventoryName,
      required String amount,
      required String serialNo,
      required String purchaseDate,
      required String endWarrantyDate,
      String? token}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addInventory,
        token: MyLocalStorage().getToken(),
        body: {
          "inventory_name": inventoryName,
          "amount": amount,
          "serial_no": serialNo,
          "purchase_date": purchaseDate,
          "end_warranty_date": endWarrantyDate,
        });
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = AddInventoryModel.fromJson(response.data);
      Logger.println("Add Inventory Report :::: ${response.data}");
      return responseData;
    } else {
      Logger.println("Add Inventory Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateInventoryModel> updateInventory({
    required String id,
    required String inventoryName,
    required String amount,
    required String serialNo,
    required String purchaseDate,
    required String endWarrantyDate,
  }) async {
    final response = await DioClient().postRequest(
      token: MyLocalStorage().getToken(),
      body: {
        "inventory_name": inventoryName,
        "amount": amount,
        "serial_no": serialNo,
        "purchase_date": purchaseDate,
        "end_warranty_date": endWarrantyDate,
      },
      url: '${Api.baseurl}${Api.updateInventory}/$id',
    );
    Logger.println("Inventory data response : ${response.data}");
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = UpdateInventoryModel.fromJson(response.data);
      Logger.println("update Inventory Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("update Inventory Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<SuccessModel> deleteInventory({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteInventory}/$id',
      token: MyLocalStorage().getToken(),
    );
    Logger.println("Inventory data response : ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete Inventory Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete Inventory Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseStatus.error![0].error.toString()
              : responseStatus.message!);
    }
  }
}
