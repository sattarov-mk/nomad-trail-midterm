import 'package:equatable/equatable.dart';

class TrailModel extends Equatable {
  final String id;
  final String name;
  final int altitude;
  final String difficulty;
  final bool isCompleted;
  final String notes;

  const TrailModel({
    required this.id,
    required this.name,
    required this.altitude,
    required this.difficulty,
    required this.isCompleted,
    required this.notes,
  });

  factory TrailModel.fromJson(Map<String, dynamic> json) {
    return TrailModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      altitude: json['altitude'] ?? 0,
      difficulty: json['difficulty'] ?? 'Средняя',
      isCompleted: json['isCompleted'] ?? false,
      notes: json['notes'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, altitude, difficulty, isCompleted, notes];
}
