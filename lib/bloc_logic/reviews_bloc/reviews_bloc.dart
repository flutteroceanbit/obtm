import 'package:bloc/bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/reviews_bloc/reviews_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/reviews_bloc/reviews_state.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'reviews_event.dart';

class MyReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewRepository reportRepository;
  MyReviewBloc({required this.reportRepository}) : super(ReviewInitial()) {
    on<GetReviewEvent>(_getReview);
    on<AddReviewEvent>(_addReview);
    // on<UpdateReview>(_updateReview);
    on<DeleteReview>(_deleteReviewType);
  }

  Future<void> _getReview(
      GetReviewEvent event, Emitter<ReviewState> emit) async {
    emit(GetReviewLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await ReviewRepository.getReview(
            token: MyLocalStorage().getToken(), userId: event.userId);

        reportRepository.clearReportList();
        reportRepository.dataList = getModel.data;
        Logger.println('getModel list data::$getModel');
        emit(GetReviewLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetReviewError(errors: e.message));
      }
    } else {
      emit(const GetReviewError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addReview(
      AddReviewEvent event, Emitter<ReviewState> emit) async {
    emit(GetReviewLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await ReviewRepository.addReview(
          token: MyLocalStorage().getToken(),
          taskCompletion: event.taskCompletion,
          socialMedia: event.socialMedia,
          id: event.id,
          behavior: event.behavior,
          remarks: event.remarks,
        );

        Logger.println('getModel list data::$getModel');
        emit(AddReviewLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(AddReviewError(errors: e.message));
      }
    } else {
      emit(const AddReviewError(errors: Strings.offlineMsg));
    }
  }

  // Future<void> _updateReview(ReviewEvent event, Emitter<ReviewState> emit) async {
  //   emit(UpdateReviewLoading());
  //
  //   if (Provider.of<ConnectivityProvider>(event.context, listen: false)
  //       .isOnline) {
  //     try {
  //       final getModel = await ReviewRepository.updateReview(
  //           id: event.id.toString(), Reviews: event.Reviews);
  //
  //       emit(UpdateReviewLoaded(data: getModel));
  //     } on ServiceException catch (e) {
  //       emit(UpdateReviewError(errors: e.message));
  //     }
  //   } else {
  //     emit(const UpdateReviewError(errors: Strings.offlineMsg));
  //   }
  // }

  Future<void> _deleteReviewType(
      ReviewEvent event, Emitter<ReviewState> emit) async {
    emit(GetReviewLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await ReviewRepository.deleteReview(id: event.id);

        emit(DeleteReviewLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteReviewError(errors: e.message));
      }
    } else {
      emit(const DeleteReviewError(errors: Strings.offlineMsg));
    }
  }
}
