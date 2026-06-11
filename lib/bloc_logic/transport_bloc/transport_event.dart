import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

abstract class TransportEvent extends Equatable {
  const TransportEvent();

  get context => null;
  get id => null;
  get userId => null;
  get transportName => null;
  get transportNumber => null;
  get rcBook => null;
  get file => null;
}

class GetTransportEvent extends TransportEvent {
  const GetTransportEvent({required this.context, required this.userId});

  @override
  final BuildContext context;
  @override
  final int userId;

  @override
  List<Object?> get props => [];
}

class AddTransportEvent extends TransportEvent {
  @override
  final String transportName;
  @override
  final String transportNumber;
  @override
  final String rcBook;
  @override
  final PlatformFile file;
  @override
  final int userId;
  @override
  final BuildContext context;

  const AddTransportEvent(this.transportName, this.transportNumber, this.rcBook,
      this.file, this.userId,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class DeleteTransportEvent extends TransportEvent {
  const DeleteTransportEvent({
    required this.context,
    required this.id,
  });

  @override
  final BuildContext context;
  @override
  final String id;

  @override
  List<Object?> get props => [];
}
