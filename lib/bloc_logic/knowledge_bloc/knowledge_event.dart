import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class GetKnowledgeEvent extends Equatable {
  const GetKnowledgeEvent();
  get context => null;
  get id => null;
  get title => null;
  get link => null;
  get desc => null;
  get language => null;
  get userId => null;
}

class FetchKnowledge extends GetKnowledgeEvent {
  const FetchKnowledge({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class AddKnowledgeEvent extends GetKnowledgeEvent {
  const AddKnowledgeEvent(
      {required this.context,
      required this.link,
      required this.language,
      required this.title,
      required this.desc,
      required this.userId});

  @override
  final BuildContext context;
  @override
  final int userId;
  @override
  final String title;
  @override
  final String link;
  @override
  final String desc;
  @override
  final String language;

  @override
  List<Object?> get props => [];
}

class UpdateKnowledge extends GetKnowledgeEvent {
  const UpdateKnowledge(
      {required this.context,
      required this.link,
      required this.language,
      required this.title,
      required this.desc,
      required this.id});

  @override
  final BuildContext context;
  @override
  final int id;
  @override
  final String title;
  @override
  final String link;
  @override
  final String desc;
  @override
  final String language;

  @override
  List<Object?> get props => [];
}

class DeleteKnowledge extends GetKnowledgeEvent {
  const DeleteKnowledge({
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
