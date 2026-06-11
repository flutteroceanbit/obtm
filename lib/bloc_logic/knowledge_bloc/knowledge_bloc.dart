import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'knowledge_event.dart';
import 'knowledge_repository.dart';
import 'knowledge_state.dart';

class KnowledgeBloc extends Bloc<GetKnowledgeEvent, KnowledgeState> {
  KnowledgeRepository reportRepository;
  KnowledgeBloc({required this.reportRepository})
      : super(GetKnowledgeInitial()) {
    on<FetchKnowledge>(_getKnowledge);
    on<AddKnowledgeEvent>(_addKnowledge);
    on<UpdateKnowledge>(_updateKnowledge);
    on<DeleteKnowledge>(_deleteKnowledgeType);
  }

  Future<void> _getKnowledge(
      GetKnowledgeEvent event, Emitter<KnowledgeState> emit) async {
    emit(GetKnowledgeLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await KnowledgeRepository.getKnowledge(
          token: MyLocalStorage().getToken(),
        );

        reportRepository.clearReportList();
        reportRepository.dataList = getModel.data;
        Logger.println('getModel list data::$getModel');
        emit(GetKnowledgeLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetKnowledgeError(errors: e.message));
      }
    } else {
      emit(GetKnowledgeError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addKnowledge(
      AddKnowledgeEvent event, Emitter<KnowledgeState> emit) async {
    emit(GetKnowledgeLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await KnowledgeRepository.addKnowledge(
          token: MyLocalStorage().getToken(),
          userId: event.userId,
          title: event.title,
          link: event.link,
          desc: event.desc,
          language: event.language,
        );

        Logger.println('getModel list data::$getModel');
        emit(AddKnowledgeLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(AddKnowledgeError(errors: e.message));
      }
    } else {
      emit(AddKnowledgeError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateKnowledge(
      GetKnowledgeEvent event, Emitter<KnowledgeState> emit) async {
    emit(UpdateKnowledgeLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await KnowledgeRepository.updateKnowledge(
            id: event.id.toString(),
            desc: event.desc,
            title: event.title,
            link: event.link,
            language: event.language);

        emit(UpdateKnowledgeLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateKnowledgeError(errors: e.message));
      }
    } else {
      emit(UpdateKnowledgeError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteKnowledgeType(
      GetKnowledgeEvent event, Emitter<KnowledgeState> emit) async {
    emit(GetKnowledgeLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await KnowledgeRepository.deleteKnowledge(id: event.id);

        emit(DeleteKnowledgeLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteKnowledgeError(errors: e.message));
      }
    } else {
      emit(DeleteKnowledgeError(errors: Strings.offlineMsg));
    }
  }
}
