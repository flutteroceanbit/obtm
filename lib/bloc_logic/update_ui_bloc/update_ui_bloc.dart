import 'package:bloc/bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_state.dart';

class UpdateUiBloc extends Bloc<UpdateUiEvent, UpdateUiState> {
  UpdateUiBloc() : super(UpdateUiInitial()) {
    on<AddUpdateUi>((event, emit) {
      emit(UpdateUiLoading());
      try {
        emit(UpdateUiLoaded(event.isUpdateUi));
      } catch (e) {
        emit(UpdateUiError());
      }
    });
    on<AddOpenDialog>((event, emit) {
      emit(OpenDialogLoading());
      try {
        emit(OpenDialogLoaded(event.isOpenDialog));
      } catch (e) {
        emit(OpenDialogError());
      }
    });
    on<BackSetting>((event, emit) {
      emit(BackLoading());
      try {
        emit(BackLoaded(event.isBack));
      } catch (e) {
        emit(BackError());
      }
    });
  }
}
