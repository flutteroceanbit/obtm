import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class OceanTeamEvent extends Equatable {
  const OceanTeamEvent();
  get context => null;
}

class FetchOceanTeam extends OceanTeamEvent {
  const FetchOceanTeam({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}
