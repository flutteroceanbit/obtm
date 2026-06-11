import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:oceanbit_timeclock/models/add_time_slot_model.dart';
import 'package:oceanbit_timeclock/models/chart_data_model.dart';
import 'package:oceanbit_timeclock/utils/date_formatter.dart';
import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../models/get_all_time_slot_model.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class TimeRepository {
  static final TimeRepository timeRepository = TimeRepository._();
  TimeRepository._();

  factory TimeRepository() {
    return timeRepository;
  }
  static Future<AddTimeSlotModel> addTimeWithStatus(
      {required String timerStatus, required String dateTime}) async {
    final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.addTimeSlot,
        token: MyLocalStorage().getToken(),
        body: {
          "action_type": timerStatus,
          "date": DateFormatter.formateDate(
              outputFormatter: 'dd-MM-yyyy',
              inputFormatter: 'yyyy-MM-dd HH:mm:ss',
              input: dateTime.toString()), //"14-04-2023",
          "time": DateFormatter.formateDate(
                  outputFormatter: 'HH:mm:ss',
                  inputFormatter: 'yyyy-MM-dd HH:mm:ss',
                  input: dateTime.toString())
              .toString() //"10:30:00",
          // "$COMMENT": "action_type value must be from [Initial In,Inter Out,Inter In,Final Out]"
        });
    Logger.println('Time error=${response.data}');
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = AddTimeSlotModel.fromJson(response.data);
      return responseData;
    } else {
      /*  var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.error ??
          errorBody.errors?.userEmail ??
          errorBody.errors?.userType ??
          errorBody.errors?.plainPassword ??
          Strings.error_failed_Time;*/
      // var responseData = ErrorModel.fromJson(jsonDecode(response.body));
      // print('Time error=${responseData.error!}');
      throw ServiceException(message: responseStatus.message!);
    }
  }

  static Future<String> addLocalTimeWithStatus(
      {required Map<String, List<Map<String, String>>> data}) async {
    final response = await DioClient().postRequest(
        url: Api.baseurl + Api.addLocalTimeSlots,
        token: MyLocalStorage().getToken(),
        body: data);
    Logger.println('add local time slot response:===$response');
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      // var responseData = AddTimeSlotModel.fromJson(jsonDecode(response.body));
      return response.statusMessage!; //return responseData;
    } else {
      /*  var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.error ??
          errorBody.errors?.userEmail ??
          errorBody.errors?.userType ??
          errorBody.errors?.plainPassword ??
          Strings.error_failed_Time;*/
      // var responseData = ErrorModel.fromJson(jsonDecode(response.body));
      // print('Time error=${responseData.error!}');
      throw ServiceException(message: responseStatus.message!);
    }
  }

  static Future<GetAllTimeSlotModel> getAllTimeSlotData() async {
    final response = await DioClient().getRequest(
        url: Api.baseurl + Api.getAllTimeSlot,
        token: MyLocalStorage().getToken());

    Logger.println('register response = ${response.data}');
    var responseStatus = GetAllTimeSlotModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetAllTimeSlotModel.fromJson(response.data);
      return responseData;
    } else {
      /*  var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.error ??
          errorBody.errors?.userEmail ??
          errorBody.errors?.userType ??
          errorBody.errors?.plainPassword ??
          Strings.error_failed_Time;*/
      var responseError = ErrorModel.fromJson(response.data);
      // print('Time error=${responseData.error!}');
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseError.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<AddTimeSlotModel> getTodayLastTimeSlotData() async {
    final response = await DioClient().getRequest(
        url: Api.baseurl + Api.getTodayLastTimeSlot,
        token: MyLocalStorage().getToken());

    Logger.println('register response = ${response.data}');
    var responseStatus = AddTimeSlotModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = AddTimeSlotModel.fromJson(response.data);
      return responseData;
    } else {
      /*  var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.error ??
          errorBody.errors?.userEmail ??
          errorBody.errors?.userType ??
          errorBody.errors?.plainPassword ??
          Strings.error_failed_Time;*/
      var responseError = ErrorModel.fromJson(response.data);
      // print('Time error=${responseData.error!}');
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseError.error![0].error.toString()
              : responseStatus.message!);
    }
  }

  static Future<ChartMonthDataModel> getCurrentMonthChartData() async {
    final response = await DioClient().getRequest(
        url: Api.baseurl + Api.getCurrentMonthChartData,
        token: MyLocalStorage().getToken());

    Logger.println('chart day wise data response = ${response.data}');
    var responseStatus = ChartMonthDataModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = ChartMonthDataModel.fromJson(response.data);
      return responseData;
    } else {
      /*  var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.error ??
          errorBody.errors?.userEmail ??
          errorBody.errors?.userType ??
          errorBody.errors?.plainPassword ??
          Strings.error_failed_Time;*/
      var responseError = ErrorModel.fromJson(response.data);
      // print('Time error=${responseData.error!}');
      throw ServiceException(
          message: responseStatus.message == 'Request Failed'
              ? responseError.error![0].error.toString()
              : responseStatus.message!);
    }
  }

/* /// Register
  static Future<TimeModel> register({
    String? USER_TYPE,
    String? FIRST_NAME,
    String? LAST_NAME,
    String? USER_EMAIL,
    String? PLAIN_PASSWORD,
    String? DATE_OF_BIRTH, //"1995-07-10",
    String? USER_MOBILE,
    String? MOBILE_COUNTRYCODE,
    String? HOWDIDUFIND,
    String? REFERRAL_CODE,
  }) async {
    final response =
    await ApiClient().postRequest(url: Api.baseurl + Api.sugnUp, body: {
      "USER_TYPE": USER_TYPE,
      "FIRST_NAME": FIRST_NAME,
      "LAST_NAME": LAST_NAME,
      "USER_EMAIL": USER_EMAIL,
      "PLAIN_PASSWORD": PLAIN_PASSWORD,
      "DATE_OF_BIRTH": DATE_OF_BIRTH,
      "USER_MOBILE": USER_MOBILE,
      "MOBILE_COUNTRYCODE": MOBILE_COUNTRYCODE,
      "HOWDIDUFIND": HOWDIDUFIND,
      "REFERRAL_CODE": REFERRAL_CODE,
    });

    if (response.statusCode == 200) {
      var responseData = TimeModel.fromJson(jsonDecode(response.body));
      return responseData;
    } else {
      var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.firstName ??
          errorBody.errors?.lastName ??
          errorBody.errors?.userEmail ??
          errorBody.errors?.userType ??
          errorBody.errors?.plainPassword ??
          errorBody.errors?.dateOfBirth ??
          errorBody.errors?.userMobile ??
          errorBody.errors?.mobileCountryCode ??
          Strings.error_failed_register;
      print('register error=${errorMessage}');
      throw ServiceException(
          message: errorMessage.toString(), error: errorBody);
    }
  }
*/

/*///verify Email
  static Future<VerifyEmail> verifyEmail({String? email}) async {
    final response = await ApiClient().postRequest(
      url: Api.baseurl + Api.verifyEmail,
      body: {'USER_EMAIL': email},
    );
    print("VerifyEmail response=${response.body}");

    if (response.statusCode == 200) {
      var responseData = VerifyEmail.fromJson(jsonDecode(response.body));
      return responseData;
    } else {
      var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.userEmail ??
          errorBody.errors?.message ??
          errorBody.errors?.error ??
          Strings.error_failed_verify_email;
      print('VerifyEmail error=${errorMessage}');
      throw ServiceException(
          message: errorMessage.toString(), error: errorBody);
    }
  }*/

/* ///update password
  static Future<SuccessModel> updatePassword(
      {String? token,
        String? oldPassword,
        String? newPassword,
        String? confirmPassword}) async {
    //try {
    final response = await ApiClient()
        .putRequest(Api.baseurl + Api.updatePassword, token: token, body: {
      'newpassword': newPassword,
      "confirmpassword": confirmPassword,
      "currentpassword": oldPassword
    });
    if (response.statusCode == 200) {
      print("reset passowrd response====${response.body}");
      SuccessModel model = SuccessModel.fromJson(jsonDecode(response.body));
      return model;
    } else {
      var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.error ??
          errorBody.errors?.confirmpassword ??
          Strings.passMatchError;
      print('Time error=${errorMessage}');
      throw ServiceException(
          message: errorMessage.toString(), error: errorBody);
    }
    // } catch (e) {
    //print(e);
    // throw ServiceException(message: 'An unknown error occurred!');
    // }
  }
*/
/*///update learning style
  static Future<String> learnStyleUpdate(
      {String? learnStyle, String? token}) async {
    try {
      final data = await BaseRequest().putRequest(
          Api.baseurl + Api.updateLearnStyle,
          token: token,
          jsonMap: {"LEARN_STYLE": learnStyle});
      print(data);

      return data;
    } catch (e) {
      print(e);
      throw ServiceException(message: 'An unknown error occurred!');
    }
  }*/

/*  ///update teaching style
  static Future<String> teachStyleUpdate(
      {String? learnStyle, String? token}) async {
    try {
      final data = await BaseRequest().putRequest(
          Api.baseurl + Api.updateTeachStyle,
          token: token,
          jsonMap: {"TEACH_STYLE": learnStyle});
      print(data);

      return data;
    } catch (e) {
      print(e);
      throw ServiceException(message: 'An unknown error occurred!');
    }
  }*/
/*
  ///subject Request
  static Future<String> subjectRequest(
      {String? token, String? subject, String? eduLevel}) async {
    try {
      final data = await BaseRequest().postRequest(
          Api.baseurl + Api.subjectRequest,
          token: token,
          {"MRSUBJECT": subject, "ED_LEVEL": eduLevel});
      print(data);

      return data;
    } catch (e) {
      print(e);
      throw ServiceException(message: 'An unknown error occurred!');
    }
  }*/

/* ///fetch Menu list
  static Future<String> fetchMenuOption() async {
    try {
      final data =
      await BaseRequest().getRequest(Api.baseurl + Api.getOptionValue);
      return data;
    } catch (e) {
      print(e);
      throw ServiceException(message: 'An unknown error occurred!');
    }
  }*/

/* ///fetch profile
  static Future<TimeModel> fetchProfile({String? token}) async {
    //  try {
    final response = await ApiClient()
        .getRequest(Api.baseurl + Api.getProfile, token: token);
    if (response.statusCode == 200) {
      var responseData = TimeModel.fromJson(jsonDecode(response.body));
      return responseData;
    } else {
      var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage =
          errorBody.errors?.error ?? Strings.error_failed_fetch_profile;
      print('Time error=${errorMessage}');
      throw ServiceException(
          message: errorMessage.toString(), error: errorBody);
      throw ServiceException(message: 'An unknown error occurred!');
    }
    */ /*} catch (e) {
      print(e);
      throw ServiceException(message: 'An unknown error occurred!');
    }*/ /*
  }*/

/*  ///update profile Picture
  static Future<http.Response> postUpdateProfilePicture({
    required String? token,
    required String filePath,
    required String fileKey,
  }) async {
    final data = await ApiClient().postMultiPart(
      url: Api.baseurl + Api.profilePictureUpdate,
      token: token,
      fileKey: fileKey,
      filePath: filePath,
    );
    return data;
  }*/
/*
  ///fetch profile
  static Future<TimeModel> updateProfile(
      {String? token,
        required String userType,
        String? firstName,
        String? lastName,
        String? userEmail,
        String? plainPassword,
        String? dateOfBirth,
        String? userMobile,
        String? mobileCountryCode,
        String? addressHiv,
        String? radius,
        String? latitude,
        String? longitude,
        String? hobbies,
        String? profilePic,
        String? gender,
        String? bio}) async {
    final response = await ApiClient().putRequest(
      Api.baseurl + Api.updateProfile,
      token: token,
      body: {
        "USER_TYPE": userType,
        "FIRST_NAME": firstName,
        "LAST_NAME": lastName,
        "USER_EMAIL": userEmail,
        "PLAIN_PASSWORD": plainPassword,
        "DATE_OF_BIRTH": dateOfBirth,
        "USER_MOBILE": userMobile,
        "MOBILE_COUNTRYCODE": mobileCountryCode,
        "ADDRESSHIV": addressHiv,
        "RADIUS": radius,
        "LATITUDE": latitude,
        "LONGITUDE": longitude,
        "HOBBIES": hobbies,
        "GENDER": gender,
        "PROFILE_PIC": profilePic,
        "TEACH_STYLE_BIO": bio
      },
    );

    if (response.statusCode == 200) {
      var responseData = TimeModel.fromJson(jsonDecode(response.body));
      return responseData;
    } else {
      var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.firstName ??
          errorBody.errors?.lastName ??
          errorBody.errors?.userEmail ??
          errorBody.errors?.userType ??
          errorBody.errors?.plainPassword ??
          errorBody.errors?.dateOfBirth ??
          errorBody.errors?.userMobile ??
          errorBody.errors?.mobileCountryCode ??
          errorBody.errors?.addressHiv ??
          errorBody.errors?.radius ??
          errorBody.errors?.latitude ??
          errorBody.errors?.longitude ??
          errorBody.errors?.hobbies ??
          errorBody.errors?.gender ??
          errorBody.errors?.profilePic ??
          errorBody.errors?.bio ??
          errorBody.errors?.error ??
          errorBody.errors?.message ??
          Strings.error_failed_update;
      print('update error=${errorMessage}');
      throw ServiceException(
          message: errorMessage.toString(), error: errorBody);
    }
  }*/
/*
  static Future<String> fetchListEducationDetail({String? token}) async {
    try {
      final data = await BaseRequest()
          .getRequest(Api.baseurl + Api.listEducationDetail, token: token);
      return data;
    } catch (e) {
      print(e);
      throw ServiceException(message: 'An unknown error occurred!');
    }
  }*/

  ///Add edication detail Request
/*static Future<String> addEducationDetail(
      {String? token,
        String? subjectType,
        String? subjects,
        String? edLevel,
        String? catLesson,
        String? typeLesson,
        String? priceLe}) async {
    try {
      final data = await BaseRequest()
          .postRequest(Api.baseurl + Api.addEducationDetail, token: token, {
        "TYPE_SUBJECT": subjectType,
        "SUBJECTS": subjects,
        "ED_LEVEL": edLevel,
        "CAT_LESSON": catLesson,
        "TYPE_LESSON": typeLesson,
        "PRICE_LE": priceLe
      });
      print(data);

      return data;
    } catch (e) {
      print(e);
      throw ServiceException(message: 'An unknown error occurred!');
    }
  }*/

/*  ///Delete education detail Request
  static Future<String> removeEducationDetail(String? eautoId,
      {String? token}) async {
    try {
      final data = await BaseRequest().deleteRequest(
        Api.baseurl + Api.removeEducationDetail + eautoId!,
        token: token,
      );
      print(data);

      return data;
    } catch (e) {
      print(e);
      throw ServiceException(message: 'An unknown error occurred!');
    }
  }*/
}
