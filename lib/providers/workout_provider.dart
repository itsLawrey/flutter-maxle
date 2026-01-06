import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_models.dart';
import '../data/exercise_data.dart';

class WorkoutProvider with ChangeNotifier {
  WorkoutArea? _selectedArea;
  WorkoutLocation? _selectedLocation;
  WorkoutPlan? _currentWorkout;
  List<WorkoutLog> _workoutHistory = [];

  // Active workout state
  DateTime? _activeWorkoutStartTime;
  Set<String> _completedExercises = {};
  int _elapsedSeconds = 0;
  bool _isResumed = false;

  WorkoutArea? get selectedArea => _selectedArea;
  WorkoutLocation? get selectedLocation => _selectedLocation;
  WorkoutPlan? get currentWorkout => _currentWorkout;
  List<WorkoutLog> get workoutHistory => _workoutHistory;

  DateTime? get activeWorkoutStartTime => _activeWorkoutStartTime;
  Set<String> get completedExercises => _completedExercises;
  int get elapsedSeconds => _elapsedSeconds;
  bool get isResumed => _isResumed;

  WorkoutProvider() {
    _loadHistory();
  }

  void selectArea(WorkoutArea area) {
    if (_selectedArea == area) {
      _selectedArea = null;
    } else {
      _selectedArea = area;
    }
    notifyListeners();
  }

  void selectLocation(WorkoutLocation location) {
    if (_selectedLocation == location) {
      _selectedLocation = null;
    } else {
      _selectedLocation = location;
    }
    notifyListeners();
  }

  void startWorkout() {
    if (_selectedArea != null && _selectedLocation != null) {
      _currentWorkout = ExerciseData.getPlan(
        _selectedArea!,
        _selectedLocation!,
      );
      _activeWorkoutStartTime = DateTime.now();
      _completedExercises = {};
      _elapsedSeconds = 0;
      _isResumed = false;
      _saveActiveWorkoutState();
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectedArea = null;
    _selectedLocation = null;
    _currentWorkout = null;
    _activeWorkoutStartTime = null;
    _completedExercises = {};
    _elapsedSeconds = 0;
    _isResumed = false;
    _clearActiveWorkoutState();
    notifyListeners();
  }

  void toggleExerciseCompletion(String exerciseName) {
    if (_completedExercises.contains(exerciseName)) {
      _completedExercises.remove(exerciseName);
    } else {
      _completedExercises.add(exerciseName);
    }
    _saveActiveWorkoutState();
    notifyListeners();
  }

  void updateElapsedSeconds(int seconds) {
    _elapsedSeconds = seconds;
    if (_elapsedSeconds % 10 == 0) {
      _saveActiveWorkoutState();
    }
    notifyListeners();
  }

  Future<void> finishWorkout({bool completed = true}) async {
    if (_currentWorkout == null) return;

    final dateToUse = _activeWorkoutStartTime ?? DateTime.now();

    final log = WorkoutLog(
      id: dateToUse.millisecondsSinceEpoch.toString(),
      date: dateToUse,
      area: _currentWorkout!.area,
      location: _currentWorkout!.location,
      completed: completed,
      duration: _elapsedSeconds ~/ 60,
      exercises: _currentWorkout!.exercises,
    );

    _workoutHistory.add(log);
    // Sort by date descending
    _workoutHistory.sort((a, b) => b.date.compareTo(a.date));

    await _saveHistory();
    clearSelection();
    notifyListeners();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? historyJson = prefs.getStringList('workout_history');

    if (historyJson != null) {
      try {
        _workoutHistory = historyJson
            .map((e) => WorkoutLog.fromJson(jsonDecode(e)))
            .toList();
        _workoutHistory.sort((a, b) => b.date.compareTo(a.date));
      } catch (e) {
        debugPrint("Error loading workout history: $e");
      }
    }
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyJson = _workoutHistory
        .map((e) => jsonEncode(e.toJson()))
        .toList();
    await prefs.setStringList('workout_history', historyJson);
    debugPrint("Workout history saved. Count: ${historyJson.length}");
  }

  List<WorkoutLog> getWorkoutsForDate(DateTime date) {
    return _workoutHistory.where((log) {
      return log.date.year == date.year &&
          log.date.month == date.month &&
          log.date.day == date.day;
    }).toList();
  }

  // Active Workout Persistence
  static const String _activeWorkoutKey = 'active_workout_state';

  Future<void> _saveActiveWorkoutState() async {
    if (_currentWorkout == null) return;
    final prefs = await SharedPreferences.getInstance();
    final state = {
      'area': _selectedArea!.index,
      'location': _selectedLocation!.index,
      'startTime': _activeWorkoutStartTime?.toIso8601String(),
      'completedExercises': _completedExercises.toList(),
      'elapsedSeconds': _elapsedSeconds,
    };
    await prefs.setString(_activeWorkoutKey, jsonEncode(state));
  }

  Future<void> _clearActiveWorkoutState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeWorkoutKey);
  }

  Future<bool> checkActiveWorkout() async {
    final prefs = await SharedPreferences.getInstance();
    final String? stateJson = prefs.getString(_activeWorkoutKey);
    if (stateJson == null) return false;

    try {
      final Map<String, dynamic> state = jsonDecode(stateJson);
      _selectedArea = WorkoutArea.values[state['area']];
      _selectedLocation = WorkoutLocation.values[state['location']];
      _currentWorkout = ExerciseData.getPlan(
        _selectedArea!,
        _selectedLocation!,
      );

      if (state['startTime'] != null) {
        _activeWorkoutStartTime = DateTime.parse(state['startTime']);
      }

      _elapsedSeconds = state['elapsedSeconds'] ?? 0;

      if (state['completedExercises'] != null) {
        _completedExercises = Set<String>.from(state['completedExercises']);
      }

      _isResumed = true;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error restoring active workout: $e");
      _clearActiveWorkoutState();
      return false;
    }
  }
}
