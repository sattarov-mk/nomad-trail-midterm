import 'package:equatable/equatable.dart';

abstract class TrailEvent extends Equatable {
  const TrailEvent();
  @override
  List<Object?> get props => [];
}

class LoadTrailsEvent extends TrailEvent {
  final String? filter;
  final String? searchQuery;

  const LoadTrailsEvent({this.filter, this.searchQuery});

  @override
  List<Object?> get props => [filter, searchQuery];
}

class AddTrailEvent extends TrailEvent {
  final String name;
  final int altitude;
  final String difficulty;
  final String notes;

  const AddTrailEvent(this.name, this.altitude, this.difficulty, this.notes);

  @override
  List<Object?> get props => [name, altitude, difficulty, notes];
}

class ToggleTrailStatusEvent extends TrailEvent {
  final String id;
  const ToggleTrailStatusEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class DeleteTrailEvent extends TrailEvent {
  final String id;
  const DeleteTrailEvent(this.id);
  @override
  List<Object?> get props => [id];
}