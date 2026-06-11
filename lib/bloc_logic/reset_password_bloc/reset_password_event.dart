import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  get id => null;

  get context => null;
}

class ResetEvent extends ResetPasswordEvent {
  @override
  final int id;
  @override
  final BuildContext context;
  const ResetEvent(this.id, {required this.context});

  @override
  List<Object?> get props => [];
}
