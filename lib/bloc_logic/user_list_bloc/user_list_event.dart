part of 'user_list_bloc.dart';

abstract class UserListEvent extends Equatable{
  const UserListEvent();

  get context => null;
}

class FetchUserListEvent extends UserListEvent{
  @override
  final BuildContext context;
  const FetchUserListEvent({required this.context});
  @override
  List<Object?> get props =>[];
}

