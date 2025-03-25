import 'package:flutter/material.dart';

class Workout {
  final String id;
  final String name;
  final String description;
  final bool isHard; // true: khó (30 điểm), false: dễ (10 điểm)
  final int experiencePoints; // Điểm kinh nghiệm khi hoàn thành
  final IconData icon;

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.isHard,
    IconData? icon,
  }) : experiencePoints = isHard ? 30 : 10,
       icon = icon ?? (isHard ? Icons.fitness_center : Icons.directions_run);

  // Chuyển đổi từ JSON sang đối tượng Workout
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isHard: json['isHard'] ?? false,
    );
  }

  // Chuyển đổi đối tượng Workout sang JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'isHard': isHard,
    };
  }
}

class DailyWorkout {
  final String id;
  final String workoutId;
  final String userId;
  final DateTime date;
  bool isCompleted;

  DailyWorkout({
    required this.id,
    required this.workoutId,
    required this.userId,
    required this.date,
    this.isCompleted = false,
  });

  // Chuyển đổi từ JSON sang đối tượng DailyWorkout
  factory DailyWorkout.fromJson(Map<String, dynamic> json) {
    return DailyWorkout(
      id: json['_id'] ?? '',
      workoutId: json['workoutId'] ?? '',
      userId: json['userId'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Chuyển đổi đối tượng DailyWorkout sang JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'workoutId': workoutId,
      'userId': userId,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
} 