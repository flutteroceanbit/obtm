import 'package:equatable/equatable.dart';
import 'package:oceanbit_timeclock/models/add_update_contact_model.dart';

abstract class AddUpdateContactDetailState extends Equatable{
  @override
  List<Object?> get props => [];
}

class AddUpdateContactDetailInitialState extends AddUpdateContactDetailState{
  @override
  List<Object?> get props => [];
}

class AddUpdateContactDetailLoading extends AddUpdateContactDetailState{
  @override
  List<Object?> get props => [];
}

class AddUpdateContactDetailLoaded extends AddUpdateContactDetailState{
  final AddUpdateContactDetailModel? addUpdateContactDetailModel;
  AddUpdateContactDetailLoaded({this.addUpdateContactDetailModel});
  @override
  List<Object?> get props => [addUpdateContactDetailModel];
}

class AddUpdateContactDetailError extends AddUpdateContactDetailState{
  final dynamic error;
  AddUpdateContactDetailError({this.error});
  @override
  List<Object?> get props => [error];
}