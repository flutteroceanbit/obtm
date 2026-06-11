part of 'user_list_bloc.dart';

abstract class UserListState extends Equatable {
  const UserListState();
}

class GetUserListInitialState extends UserListState {
  @override
  List<Object?> get props => [];
}

class GetUserListLoadingState extends UserListState {
  @override
  List<Object?> get props => [];
}

class GetUserListLoadedState extends UserListState {
  final UserListModel? data;
  const GetUserListLoadedState({this.data});
  @override
  List<Object?> get props => [data!];
}

class GetUserListErrorState extends UserListState {
  const GetUserListErrorState({this.error});
  final dynamic error;
  @override
  List<Object?> get props => [];
}
