import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'rules_event.dart';
import 'rules_repository.dart';
import 'rules_state.dart';

class RulesBloc extends Bloc<RulesEvent, RulesState> {
  RulesRepository reportRepository;
  RulesBloc({required this.reportRepository}) : super(RulesInitial()) {
    on<GetRules>(_getRules);
    on<AddRulesEvent>(_addRules);
    on<UpdateRules>(_updateRules);
    on<DeleteRules>(_deleteRulesType);
  }

  Future<void> _getRules(RulesEvent event, Emitter<RulesState> emit) async {
    emit(GetRulesLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await RulesRepository.getRules(
          token: MyLocalStorage().getToken(),
        );

        reportRepository.clearReportList();
        reportRepository.dataList = getModel.data;
        Logger.println('getModel list data::$getModel');
        emit(GetRulesLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetRulesError(errors: e.message));
      }
    } else {
      emit(GetRulesError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addRules(AddRulesEvent event, Emitter<RulesState> emit) async {
    emit(GetRulesLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await RulesRepository.addRules(
          token: MyLocalStorage().getToken(),
          rule: event.rule,
        );

        Logger.println('getModel list data::$getModel');
        emit(AddRulesLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(AddRulesError(errors: e.message));
      }
    } else {
      emit(AddRulesError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateRules(RulesEvent event, Emitter<RulesState> emit) async {
    emit(UpdateRulesLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await RulesRepository.updateRules(
          id: event.id.toString(),
          rule: event.rule,
        );

        emit(UpdateRulesLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateRulesError(errors: e.message));
      }
    } else {
      emit(UpdateRulesError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteRulesType(
      RulesEvent event, Emitter<RulesState> emit) async {
    emit(GetRulesLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await RulesRepository.deleteRules(id: event.id.toString());

        emit(DeleteRulesLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteRulesError(errors: e.message));
      }
    } else {
      emit(DeleteRulesError(errors: Strings.offlineMsg));
    }
  }
}
