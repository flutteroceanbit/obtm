part of 'add_update_personal_detail_bloc.dart';

abstract class AddUpdatePersonalDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddUpdatePersonalDetailInitialState extends AddUpdatePersonalDetailState {
  @override
  List<Object?> get props => [];
}

class AddUpdatePersonalDetailLoading extends AddUpdatePersonalDetailState {
  @override
  List<Object?> get props => [];
}

class AddUpdatePersonalDetailLoaded extends AddUpdatePersonalDetailState {
  final AddUpdatePersonalDetailModel? dataModel;
  AddUpdatePersonalDetailLoaded({this.dataModel});
  @override
  List<Object?> get props => [dataModel!];
}

class AddUpdatePersonalDetailError extends AddUpdatePersonalDetailState {
  final dynamic error;
  AddUpdatePersonalDetailError({this.error});
  @override
  List<Object?> get props => [error];
}

///update user

class UserUpdateLoading extends AddUpdatePersonalDetailState {
  @override
  List<Object?> get props => [];
}

class UserUpdateLoaded extends AddUpdatePersonalDetailState {
  final UpdateUserModel? dataModel;
  UserUpdateLoaded({this.dataModel});
  @override
  List<Object?> get props => [dataModel!];
}

class UserUpdateError extends AddUpdatePersonalDetailState {
  final dynamic error;
  UserUpdateError({this.error});
  @override
  List<Object?> get props => [error];
}

class UserStatusUpdateLoading extends AddUpdatePersonalDetailState {
  @override
  List<Object?> get props => [];
}

class UserStatusUpdateLoaded extends AddUpdatePersonalDetailState {
  final UpdateUserModel? dataModel;
  UserStatusUpdateLoaded({this.dataModel});
  @override
  List<Object?> get props => [dataModel!];
}

class UserStatusUpdateError extends AddUpdatePersonalDetailState {
  final dynamic error;
  UserStatusUpdateError({this.error});
  @override
  List<Object?> get props => [error];
}
