import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/error_model.dart';
import '../../models/review/add_review_model.dart';
import '../../models/review/get_all_employee_review_model.dart';
import '../../models/success_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class ReviewRepository {
  static final ReviewRepository getReviewRepository = ReviewRepository._();

  ReviewRepository._();

  factory ReviewRepository() {
    return getReviewRepository;
  }

  final List<AllReviewData> _data = [];

  List<AllReviewData> get dataList => _data;

  set dataList(List<AllReviewData>? value) {
    _data.addAll(value!);
  }

  clearReportList() {
    _data.clear();
    dataList.clear();
  }

  static Future<GetAllEmployeeReviewModel> getReview({
    String? token,
    int? userId,
  }) async {
    print('userId :: $userId');
    final response = await DioClient().postRequest(
      url: '${Api.baseurl}${Api.getAllEmployeeReview}',
      token: token,
      body: userId != null ? {'user_id': userId} : {},
    );
    var responseStatus = GetAllEmployeeReviewModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = GetAllEmployeeReviewModel.fromJson(response.data);
      Logger.println('Review response ::: $responseData');
      return responseData;
    } else {
      Logger.println("Review Error ::: ${response.data}");
      var responseError = GetAllEmployeeReviewModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }

  static Future<AddReviewModel> addReview({
    required int socialMedia,
    required int id,
    required int behavior,
    required String remarks,
    required int taskCompletion,
    String? token,
  }) async {
    final response = await DioClient().postMultipartRequest(
      url: Api.baseurl + Api.addReview,
      token: MyLocalStorage().getToken(),
      body: {
        "id": id.toString(),
        "social_media": socialMedia.toString(),
        "task_completion": taskCompletion.toString(),
        "behavior": behavior.toString(),
        "remarks": remarks ?? '',
      },
    );
    var responseStatus = response.data;
    if (responseStatus['status'] == true) {
      var responseData = AddReviewModel.fromJson(response.data);
      Logger.println("Add Review Report :::: ${responseData.data}");
      return responseData;
    } else {
      Logger.println("Add Review Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
        message: responseStatus.message == 'Request Failed'
            ? responseStatus.error![0].error.toString()
            : responseStatus.message!,
      );
    }
  }

  // static Future<UpdateReviewModel> updateReview({
  //   required String id,
  //   required String Reviews,
  // }) async {
  //   final response = await ApiClient().postRequest(
  //     token: MyLocalStorage().getToken(),
  //     body: {
  //       "Reviews": Reviews,
  //     },
  //     url: '${Api.baseurl}${Api.updateReview}/$id',
  //   );
  //   Logger.println("Review data response : ${response.body}");
  //   var responseStatus = jsonDecode(response.body);
  //   if (responseStatus['status'] == true) {
  //     var responseData = UpdateReviewModel.fromJson(jsonDecode(response.body));
  //     Logger.println("update Review Report :::: $responseData");
  //     return responseData;
  //   } else {
  //     Logger.println("update Review Report Error :::: ${response.body}");
  //     var responseStatus = ErrorModel.fromJson(jsonDecode(response.body));
  //     throw ServiceException(
  //         message: responseStatus.message == 'Request Failed'
  //             ? responseStatus.error![0].error.toString()
  //             : responseStatus.message!);
  //   }
  // }

  static Future<SuccessModel> deleteReview({required String id}) async {
    final response = await DioClient().deleteRequest(
      url: '${Api.baseurl}${Api.deleteReview}/$id',
      token: MyLocalStorage().getToken(),
    );
    Logger.println("Review data response : ${response.data}");
    var responseStatus = SuccessModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = SuccessModel.fromJson(response.data);
      Logger.println("delete Review Report :::: $responseData");
      return responseData;
    } else {
      Logger.println("delete Review Report Error :::: ${response.data}");
      var responseStatus = ErrorModel.fromJson(response.data);
      throw ServiceException(
        message: responseStatus.message == 'Request Failed'
            ? responseStatus.error![0].error.toString()
            : responseStatus.message!,
      );
    }
  }
}
