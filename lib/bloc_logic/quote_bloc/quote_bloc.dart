import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'quote_event.dart';
import 'quote_repository.dart';
import 'quote_state.dart';

class MyQuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  QuoteRepository reportRepository;
  MyQuoteBloc({required this.reportRepository}) : super(QuoteInitial()) {
    on<GetQuoteEvent>(_getQuote);
    on<AddQuoteEvent>(_addQuote);
    on<UpdateQuote>(_updateQuote);
    on<DeleteQuote>(_deleteQuoteType);
  }

  Future<void> _getQuote(GetQuoteEvent event, Emitter<QuoteState> emit) async {
    emit(GetQuoteLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await QuoteRepository.getQuote(
          token: MyLocalStorage().getToken(),
        );

        reportRepository.clearReportList();
        reportRepository.dataList = getModel.data;
        Logger.println('getModel list data::$getModel');
        emit(GetQuoteLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetQuoteError(errors: e.message));
      }
    } else {
      emit(const GetQuoteError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addQuote(AddQuoteEvent event, Emitter<QuoteState> emit) async {
    emit(GetQuoteLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await QuoteRepository.addQuote(
          token: MyLocalStorage().getToken(),
          quotes: event.quotes,
        );

        Logger.println('getModel list data::$getModel');
        emit(AddQuoteLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(AddQuoteError(errors: e.message));
      }
    } else {
      emit(const AddQuoteError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateQuote(QuoteEvent event, Emitter<QuoteState> emit) async {
    emit(UpdateQuoteLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await QuoteRepository.updateQuote(
            id: event.id.toString(), quotes: event.quotes);

        emit(UpdateQuoteLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateQuoteError(errors: e.message));
      }
    } else {
      emit(const UpdateQuoteError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteQuoteType(
      QuoteEvent event, Emitter<QuoteState> emit) async {
    emit(GetQuoteLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await QuoteRepository.deleteQuote(id: event.id);

        emit(DeleteQuoteLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteQuoteError(errors: e.message));
      }
    } else {
      emit(const DeleteQuoteError(errors: Strings.offlineMsg));
    }
  }
}
