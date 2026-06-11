import '../../constant/api.dart';
import '../../http/api_client.dart';
import '../../models/get_ocean_team_model.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class GetOceanTeamRepository {
  static final GetOceanTeamRepository getOceanTeamRepository =
      GetOceanTeamRepository._();

  GetOceanTeamRepository._();

  factory GetOceanTeamRepository() {
    return getOceanTeamRepository;
  }

  List<TeamData> oceanTeamList = [];

  static Future<OceanTeamModel> getOceanTeam({String? token}) async {
    final response = await DioClient().getRequest(
      url: '${Api.baseurl}${Api.allOceanTeams}',
      token: token,
    );
    var responseStatus = OceanTeamModel.fromJson(response.data);
    if (responseStatus.status == true) {
      var responseData = OceanTeamModel.fromJson(response.data);
      Logger.println('responseData ::: $responseData');
      return responseData;
    } else {
      Logger.println("OceanTeam Error ::: ${response.data}");
      var responseError = OceanTeamModel.fromJson(response.data);
      throw ServiceException(message: responseError.message);
    }
  }
}
