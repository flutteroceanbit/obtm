import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:oceanbit_timeclock/models/error_model.dart';
import 'package:oceanbit_timeclock/models/success_model.dart';
import 'package:oceanbit_timeclock/models/update_user.dart';
import '../../constant/api.dart';
import '../../constant/strings.dart';
import '../../http/api_client.dart';
import '../../models/add_update_profile_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class AddUpdatePersonalDetailRepository {
  static Future<AddUpdatePersonalDetailModel> getAddUpdatePersonalDetail(
      {String? token,
      required int id,
      String? middleName,
      required String dob,
      required String? fatherFullName,
      String? fatherOccupation,
      String? education,
      required String gender,
      String? boolGroup,
      String? aadharCardNumber,
      String? panCardNumber}) async {
    Logger.println("AddUpdatePersonalDetailRepository");
    final response = await DioClient().postRequest(
        url: Api.baseurl + Api.addUpdatePersonalDetail,
        body: {
          "id": id.toString(),
          "middle_name": middleName.toString(),
          "dob": dob.toString(), //dd-MM-yyyy format
          "father_full_name": fatherFullName.toString(),
          "father_occupation": fatherOccupation.toString(),
          "education": education,
          "gender": gender == Strings.genderList[0] ? 'M' : 'F',
          "blood_group": boolGroup,
          "aadhar_card": aadharCardNumber.toString(),
          "pan_card": panCardNumber.toString()
        },
        token: token);
    var responseStatus = AddUpdatePersonalDetailModel.fromJson(response.data);
    Logger.println(
        "Response from add update user detail detail :: ${responseStatus.status}");
    if (responseStatus.status == true) {
      var responseData = AddUpdatePersonalDetailModel.fromJson(response.data);
      return responseData;
    } else {
      var responseData = ErrorModel.fromJson(response.data);
      Logger.println(
          "User Detail List Error :::: ${responseData.error![0].error}");
      throw ServiceException(
          message: responseData.message == 'Request Failed'
              ? responseData.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<UpdateUserModel> updateUser({
    String? token,
    String? firstName,
    String? lastName,
    required int id,
  }) async {
    final response = await DioClient().postRequest(
      url: '${Api.baseurl}${Api.userUpdate}?id=$id',
      body: {
        "first_name": firstName.toString(),
        "last_name": lastName.toString(),
      },
      token: token,
    );
    var responseStatus = UpdateUserModel.fromJson(response.data);
    Logger.println(
        "Response from update user detail detail :: ${responseStatus.status}");
    if (responseStatus.status == true) {
      var responseData = UpdateUserModel.fromJson(response.data);
      return responseData;
    } else {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("Update User Error :::: ${responseData.error}");
      throw ServiceException(message: responseData.error.toString());
    }
  }

  static Future<UpdateUserModel> updateUserWithImage({
    String? token,
    String? firstName,
    String? lastName,
    String? image,
    PlatformFile? file,
    required int id,
  }) async {
    final response = await DioClient().postMultiPart(
        url: '${Api.baseurl}${Api.userUpdate}?id=$id',
        body: {
          "first_name": firstName.toString(),
          "last_name": lastName.toString(),
        },
        token: token,
        fileKey: 'image_url',
        file: file,
        filePath: image);
    var responseStatus = UpdateUserModel.fromJson(response.data);
    Logger.println(
        "Response from update user detail detail :: ${responseStatus.status}");
    if (responseStatus.status == true) {
      var responseData = UpdateUserModel.fromJson(response.data);
      return responseData;
    } else {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("Update User Error :::: ${responseData.error}");
      throw ServiceException(message: responseData.error.toString());
    }
  }

  static Future<UpdateUserModel> updateUserStatus({
    String? token,
    String? isActive,
    required int id,
  }) async {
    final response = await DioClient().postRequest(
        url: Api.baseurl + Api.changeIsActive,
        body: {"is_active": isActive, "id": id},
        token: token);
    var responseStatus = UpdateUserModel.fromJson(response.data);
    Logger.println(
        "Response from update user detail detail :: ${responseStatus.status}");
    if (responseStatus.status == true) {
      var responseData = UpdateUserModel.fromJson(response.data);
      return responseData;
    } else {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("Update User Error :::: ${responseData.error}");
      throw ServiceException(message: responseData.error.toString());
    }
  }
}
