import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/streak.dart';
import '../models/weight_entry.dart';
import '../models/checkin.dart';

class AppProvider with ChangeNotifier {
  Streak _streak = Streak();
  List<WeightEntry> _weightLogs = [];
  List<CheckIn> _checkIns = [];
  String _nickname = "Aspirant";
  String _profileImageIndex = "0"; // now can be an index string or local path

  // Gamification
  int _currentXP = 0;
  int _currentLevel = 1;
  String _rankName = "Novice";

  Streak get streak => _streak;
  List<WeightEntry> get weightLogs => _weightLogs;
  List<CheckIn> get checkIns => _checkIns;
  String get nickname => _nickname;
  String get profileImageIndex => _profileImageIndex;

  int get currentXP => _currentXP;
  int get currentLevel => _currentLevel;
  String get rankName => _rankName;

  // XP Calculation
  int get xpToNextLevel => _currentLevel * 100;
  double get progressToNextLevel => _currentXP / xpToNextLevel;

  AppProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Streak
    int count = prefs.getInt('streakCount') ?? 0;
    String? dateStr = prefs.getString('lastCheckIn');
    CheckIn? lastCheckIn = dateStr != null
        ? CheckIn(date: DateTime.parse(dateStr))
        : null;
    _streak = Streak(count: count, lastCheckIn: lastCheckIn);

    // Load Weight Logs
    List<String>? weightList = prefs.getStringList('weightLogs');
    if (weightList != null) {
      try {
        _weightLogs = weightList
            .map((e) => WeightEntry.fromJson(jsonDecode(e)))
            .toList();
        _weightLogs.sort((a, b) => b.date.compareTo(a.date)); // Newest first
      } catch (e) {
        debugPrint("Error loading weight logs: $e");
      }
    }

    // Load CheckIns
    _checkIns = [];

    // 1. Load from SharedPreferences
    List<String>? checkInList = prefs.getStringList('checkIns');
    if (checkInList != null) {
      try {
        _checkIns = checkInList
            .map((e) => CheckIn.fromJson(jsonDecode(e)))
            .toList();
      } catch (e) {
        debugPrint("Error loading checkins: $e");
      }
    }

    // 2. Add Dummy Data (merged, not overwriting)
    // REMOVED DUMMY DATA FOR PRODUCTION READINESS
    // If you need to re-enable testing data, uncomment or add a debug flag.

    // Sort
    _checkIns.sort((a, b) => a.date.compareTo(b.date));

    _nickname = prefs.getString('nickname') ?? "Aspirant";
    _profileImageIndex = prefs.getString('profileImageIndex') ?? "0";

    // Load Gamification
    _currentXP = prefs.getInt('currentXP') ?? 0;
    _currentLevel = prefs.getInt('currentLevel') ?? 1;
    _calculateRank();

    notifyListeners();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save Streak
    prefs.setInt('streakCount', _streak.count);
    if (_streak.lastCheckIn != null) {
      prefs.setString(
        'lastCheckIn',
        _streak.lastCheckIn!.date.toIso8601String(),
      );
    }

    // Save Weight Logs
    List<String> weightList = _weightLogs
        .map((e) => jsonEncode(e.toJson()))
        .toList();
    prefs.setStringList('weightLogs', weightList);

    // Save CheckIns
    List<String> checkInList = _checkIns
        .map((e) => jsonEncode(e.toJson()))
        .toList();
    prefs.setStringList('checkIns', checkInList);

    prefs.setString('nickname', _nickname);
    prefs.setString('profileImageIndex', _profileImageIndex);

    // Save Gamification
    prefs.setInt('currentXP', _currentXP);
    prefs.setInt('currentLevel', _currentLevel);
  }

  void checkIn() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_streak.lastCheckIn != null) {
      final last = _streak.lastCheckIn!.date;
      final lastDate = DateTime(last.year, last.month, last.day);

      if (lastDate.isAtSameMomentAs(today)) {
        return; // Already checked in today
      } else if (lastDate.difference(today).inDays == -1) {
        _streak.count++;
      } else {
        _streak.count = 1; // Missed a day or more
      }
    } else {
      _streak.count = 1;
    }

    _streak.lastCheckIn = CheckIn(date: now);
    _checkIns.add(CheckIn(date: now));

    // Add XP for check-in
    addXP(10);

    saveData();
    notifyListeners();
  }

  void addWeightEntry(WeightEntry entry) {
    // Check if weight already logged today for XP limit
    final today = DateTime.now();
    final hasLoggedToday = _weightLogs.any(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
    );

    _weightLogs.add(entry);
    _weightLogs.sort((a, b) => b.date.compareTo(a.date));

    if (!hasLoggedToday) {
      addXP(20);
    } else {
      saveData();
      notifyListeners();
    }
  }

  void removeWeightEntry(String id) {
    _weightLogs.removeWhere((e) => e.id == id);
    saveData();
    notifyListeners();
  }

  bool get hasCheckedInToday {
    if (_streak.lastCheckIn == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last = _streak.lastCheckIn!.date;
    final lastDate = DateTime(last.year, last.month, last.day);
    return lastDate.isAtSameMomentAs(today);
  }

  double? get currentWeeklyAverage {
    if (_weightLogs.isEmpty) return null;

    final now = DateTime.now();
    // Calculate start of the week (Monday)
    // weekday 1 = Monday, 7 = Sunday
    // subtract (weekday - 1) days to get to Monday
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final thisWeekLogs = _weightLogs.where((entry) {
      // Compare only dates, ignore time
      final entryDate = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );
      // We want entries >= startOfWeek
      return entryDate.isAtSameMomentAs(startOfWeek) ||
          entryDate.isAfter(startOfWeek);
    }).toList();

    if (thisWeekLogs.isEmpty) return null;

    final sum = thisWeekLogs.fold(
      0.0,
      (prev, element) => prev + element.weight,
    );
    return sum / thisWeekLogs.length;
  }

  double? get previousWeeklyAverage {
    if (_weightLogs.isEmpty) return null;

    final now = DateTime.now();
    // Start of this week (Monday)
    final startOfThisWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    // Start of last week (Monday)
    final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));

    final lastWeekLogs = _weightLogs.where((entry) {
      final entryDate = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );
      // We want entries >= startOfLastWeek AND < startOfThisWeek
      return (entryDate.isAtSameMomentAs(startOfLastWeek) ||
              entryDate.isAfter(startOfLastWeek)) &&
          entryDate.isBefore(startOfThisWeek);
    }).toList();

    if (lastWeekLogs.isEmpty) return null;

    final sum = lastWeekLogs.fold(
      0.0,
      (prev, element) => prev + element.weight,
    );
    return sum / lastWeekLogs.length;
  }

  bool isDayComplete(DateTime day) {
    return _checkIns.any((checkIn) {
      return checkIn.date.year == day.year &&
          checkIn.date.month == day.month &&
          checkIn.date.day == day.day;
    });
  }

  bool isWeekComplete(DateTime day) {
    // Find Monday of this week
    final monday = day.subtract(Duration(days: day.weekday - 1));
    for (int i = 0; i < 7; i++) {
      final checkDay = monday.add(Duration(days: i));
      // Stop checking if day is in future (optional, but requested "if whole week is full")
      // User likely implies "past full week" or "current week so far".
      // Usually "full week of streaks" means 7 days.
      if (checkDay.isAfter(DateTime.now())) {
        return false; // Can't have full week if in future?
      }

      if (!isDayComplete(checkDay)) {
        return false;
      }
    }
    return true;
  }

  bool isMonthComplete(DateTime day) {
    final daysInMonth = DateUtils.getDaysInMonth(day.year, day.month);
    for (int i = 1; i <= daysInMonth; i++) {
      final checkDay = DateTime(day.year, day.month, i);
      if (checkDay.isAfter(DateTime.now())) {
        return false; // Incomplete if month not over?
      }
      if (!isDayComplete(checkDay)) {
        return false;
      }
    }
    return true;
  }

  void updateUserProfile({String? nickname, String? profileImageIndex}) {
    if (nickname != null) _nickname = nickname;
    if (profileImageIndex != null) _profileImageIndex = profileImageIndex;
    saveData();
    notifyListeners();
  }

  // Gamification Logic
  void addXP(int amount) {
    _currentXP += amount;
    _checkLevelUp();
    saveData();
    notifyListeners();
  }

  void _checkLevelUp() {
    int required = xpToNextLevel;
    while (_currentXP >= required) {
      _currentXP -= required;
      _currentLevel++;
      required = xpToNextLevel;
    }
    _calculateRank();
  }

  void _calculateRank() {
    // 10 Ranks, changing every 10 levels
    // Level 1-9: Novice
    // Level 10-19: Beginner
    // ...
    final int rankIndex = (_currentLevel ~/ 10).clamp(0, 9);
    const ranks = [
      "Novice",
      "Beginner",
      "Intermediate",
      "Advanced",
      "Elite",
      "ProDelegate",
      "Master",
      "Grandmaster",
      "Legend",
      "Demigod",
    ];
    _rankName = ranks[rankIndex];
  }
}
