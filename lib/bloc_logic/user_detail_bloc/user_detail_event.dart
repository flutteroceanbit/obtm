part of'user_detail_bloc.dart';

abstract class UserDetailEvent extends Equatable{
  const UserDetailEvent();
  get id => null;

  get month => null;

  get context => null;
}

class FetchUserDetailEvent extends UserDetailEvent{
  @override
  final String id;
  @override
  final BuildContext context;
  const FetchUserDetailEvent({required this.id,required this.context});
  @override
  List<Object?> get props => [id];
}

class FetchUserProfileEvent extends UserDetailEvent{
  @override
  final BuildContext context;
  const FetchUserProfileEvent({required this.context});
  @override
  List<Object?> get props => [];
}