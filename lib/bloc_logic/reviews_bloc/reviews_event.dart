import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();
  get context => null;
  get id => null;
  get remarks => null;
  get behavior => null;
  get taskCompletion => null;
  get socialMedia => null;
  get userId => null;
}

class GetReviewEvent extends ReviewEvent {
  const GetReviewEvent({required this.context, this.userId});

  @override
  final BuildContext context;
  @override
  final int? userId;
  @override
  List<Object?> get props => [];
}

class AddReviewEvent extends ReviewEvent {
  const AddReviewEvent({
    required this.context,
    required this.remarks,
    required this.behavior,
    required this.socialMedia,
    required this.taskCompletion,
    required this.id,
  });

  @override
  final BuildContext context;
  @override
  final String remarks;
  @override
  final int behavior;
  @override
  final int socialMedia;
  @override
  final int taskCompletion;
  @override
  final int id;

  @override
  List<Object?> get props => [];
}

// class UpdateReview extends ReviewEvent {
//   const UpdateReview(
//       {required this.context, required this.Reviews, required this.id});
//
//   @override
//   final BuildContext context;
//   @override
//   final int id;
//   @override
//   final String Reviews;
//
//   @override
//   List<Object?> get props => [];
// }

class DeleteReview extends ReviewEvent {
  const DeleteReview({
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
