import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'get_ocean_team_event.dart';
import 'get_ocean_team_repository.dart';
import 'get_ocean_team_state.dart';

class GetOceanTeamBloc extends Bloc<OceanTeamEvent, OceanTeamState> {
  GetOceanTeamRepository reportRepository;
  GetOceanTeamBloc({required this.reportRepository})
    : super(OceanTeamInitial()) {
    on<FetchOceanTeam>(_getOceanTeam);
  }

  Future<void> _getOceanTeam(
    OceanTeamEvent event,
    Emitter<OceanTeamState> emit,
  ) async {
    emit(GetOceanTeamLoading());

    if (Provider.of<ConnectivityProvider>(
      event.context,
      listen: false,
    ).isOnline) {
      try {
        final getModel = await GetOceanTeamRepository.getOceanTeam(
          token: MyLocalStorage().getToken(),
        );

        reportRepository.oceanTeamList = getModel.data;
        Logger.println('getModel list data::$getModel');
        emit(GetOceanTeamLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetOceanTeamError(errors: e.message));
      }
    } else {
      emit(GetOceanTeamError(errors: Strings.offlineMsg));
    }
  }
}
