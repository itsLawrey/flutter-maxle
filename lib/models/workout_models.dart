enum WorkoutArea { bicepBack, tricepChest, legsShoulders, stretching }

enum WorkoutLocation { gym, home, calisthenics }

class Exercise {
  final String name;
  final String description; // Optional: brief instruction
  final int sets;
  final int reps;

  const Exercise({
    required this.name,
    this.description = '',
    this.sets = 3,
    this.reps = 12,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'sets': sets,
    'reps': reps,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'],
    description: json['description'] ?? '',
    sets: json['sets'] ?? 3,
    reps: json['reps'] ?? 12,
  );
}

class WorkoutPlan {
  final WorkoutArea area;
  final WorkoutLocation location;
  final List<Exercise> exercises;

  const WorkoutPlan({
    required this.area,
    required this.location,
    required this.exercises,
  });
}

class WorkoutLog {
  final String id;
  final DateTime date;
  final WorkoutArea area;
  final WorkoutLocation location;
  final bool completed;
  final int duration; // in seconds
  final List<Exercise> exercises;

  WorkoutLog({
    required this.id,
    required this.date,
    required this.area,
    required this.location,
    this.completed = true,
    required this.duration,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'area': area.index,
    'location': location.index,
    'completed': completed,
    'duration': duration,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  factory WorkoutLog.fromJson(Map<String, dynamic> json) => WorkoutLog(
    id: json['id'],
    date: DateTime.parse(json['date']),
    area: WorkoutArea.values[json['area']],
    location: WorkoutLocation.values[json['location']],
    completed: json['completed'] ?? true,
    duration: json['duration'] ?? 0,
    exercises:
        (json['exercises'] as List?)
            ?.map((e) => Exercise.fromJson(e))
            .toList() ??
        [],
  );
}
