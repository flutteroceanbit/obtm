import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AddUpdateContactDetailEvent extends Equatable {
  const AddUpdateContactDetailEvent();

  get id => null;

  get email => null;

  get permanentAddress => null;

  get correspondenceAddress => null;

  get parentsPhone => null;

  get context => null;
}

class FetchAndUpdateContactDetailEvent extends AddUpdateContactDetailEvent {
  @override
  final int id;
  @override
  final String email;
  @override
  final String permanentAddress;
  @override
  final String correspondenceAddress;
  @override
  final String parentsPhone;
  @override
  final BuildContext context;

  const FetchAndUpdateContactDetailEvent(
      {required this.id,
      required this.email,
      required this.permanentAddress,
      required this.correspondenceAddress,
      required this.parentsPhone,
      required this.context});

  @override
  List<Object?> get props => [];
}
