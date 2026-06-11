import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../models/auth_model.dart';
import '../../models/error_model.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class AuthRepository {
  static Future<AuthModel> login({
    String? email,
    String? password,
    String? userType,
  }) async {
    final response = await DioClient().postRequest(
      url: Api.baseurl + Api.login,
      body: {'email': email!, 'password': password!},
    );
    Logger.println('login error=${response.data}');
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = AuthModel.fromJson(response.data);
      return responseData;
    } else {
      /*  var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.error ??
          errorBody.errors?.userEmail ??
          errorBody.errors?.userType ??
          errorBody.errors?.plainPassword ??
          Strings.error_failed_login;*/
      // var responseData = ErrorModel.fromJson(jsonDecode(response.body));
      // print('login error=${responseData.error!}');
      throw ServiceException(message: responseStatus.error!);
    }
  }

  static Future<AuthModel> register({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
  }) async {
    final response = await DioClient().postMultipartRequest(
      url: Api.baseurl + Api.register,
      body: {
        'first_name': firstName!,
        'last_name': lastName!,
        'email': email!,
        'phone': phone!,
        'password': password!,
        'confirm_password': confirmPassword!,
      },
    );

    Logger.println('register response = ${response.data}');
    var responseStatus = AuthModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = AuthModel.fromJson(response.data);
      return responseData;
    } else {
      /*  var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage = errorBody.errors?.error ??
          errorBody.errors?.userEmail ??
          errorBody.errors?.userType ??
          errorBody.errors?.plainPassword ??
          Strings.error_failed_login;*/
      var responseError = ErrorModel.fromJson(response.data);
      // print('login error=${responseData.error!}');
      throw ServiceException(
        message: responseStatus.message == 'Request Failed'
            ? responseError.error![0].error.toString()
            : responseStatus.message!,
      );
    }
  }

  /* /// Register
  static Future<AuthModel> register({
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
      var responseData = AuthModel.fromJson(jsonDecode(response.body));
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
      print('login error=${errorMessage}');
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
  static Future<AuthModel> fetchProfile({String? token}) async {
    //  try {
    final response = await ApiClient()
        .getRequest(Api.baseurl + Api.getProfile, token: token);
    if (response.statusCode == 200) {
      var responseData = AuthModel.fromJson(jsonDecode(response.body));
      return responseData;
    } else {
      var errorBody = ErrorModel.fromJson(jsonDecode(response.body));

      var errorMessage =
          errorBody.errors?.error ?? Strings.error_failed_fetch_profile;
      print('login error=${errorMessage}');
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
  static Future<AuthModel> updateProfile(
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
      var responseData = AuthModel.fromJson(jsonDecode(response.body));
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
