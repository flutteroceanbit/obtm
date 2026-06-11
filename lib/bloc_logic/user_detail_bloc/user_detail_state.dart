part of'user_detail_bloc.dart';

abstract class UserDetailState extends Equatable{
  @override
  List<Object?> get props => [];
}

class UserDetailInitialState extends UserDetailState{
  @override
  List<Object?> get props => [];
}

class UserDetailLoadingState extends UserDetailState{
  @override
  List<Object?> get props => [];
}

class UserDetailLoadedState extends UserDetailState{
  final UserData? data;
  UserDetailLoadedState({this.data});
  @override
  List<Object?> get props => [data!];
}

class UserDetailErrorState extends UserDetailState{
  final dynamic error;
  UserDetailErrorState({this.error});
  @override
  List<Object?> get props => [error];
}
class UserProfileLoadingState extends UserDetailState{
  @override
  List<Object?> get props => [];
}

class UserProfileLoadedState extends UserDetailState{
  final UserData? data;
  UserProfileLoadedState({this.data});
  @override
  List<Object?> get props => [data!];
}

class UserProfileErrorState extends UserDetailState{
  final dynamic error;
  UserProfileErrorState({this.error});
  @override
  List<Object?> get props => [error];
}