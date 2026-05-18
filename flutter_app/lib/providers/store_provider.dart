import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LevelStatus { locked, unlocked, completed }

class UserState {
  final String name;
  final String grade;
  final int exp;
  final int studyMinutes;
  final String studyDate;
  final List<LevelStatus> levelStatuses;
  final List<List<int>> unitsCompleted;
  final bool loggedIn;

  UserState({
    this.name = '',
    this.grade = '',
    this.exp = 0,
    this.studyMinutes = 0,
    String? studyDate,
    List<LevelStatus>? levelStatuses,
    List<List<int>>? unitsCompleted,
    this.loggedIn = false,
  })  : studyDate = studyDate ?? _todayStr(),
        levelStatuses = levelStatuses ??
            [LevelStatus.unlocked, LevelStatus.locked, LevelStatus.locked, LevelStatus.locked, LevelStatus.locked],
        unitsCompleted = unitsCompleted ?? List.generate(5, (_) => List.filled(5, 0));

  static String _todayStr() {
    return DateTime.now().toIso8601String().substring(0, 10);
  }

  UserState copyWith({
    String? name,
    String? grade,
    int? exp,
    int? studyMinutes,
    String? studyDate,
    List<LevelStatus>? levelStatuses,
    List<List<int>>? unitsCompleted,
    bool? loggedIn,
  }) {
    return UserState(
      name: name ?? this.name,
      grade: grade ?? this.grade,
      exp: exp ?? this.exp,
      studyMinutes: studyMinutes ?? this.studyMinutes,
      studyDate: studyDate ?? this.studyDate,
      levelStatuses: levelStatuses ?? this.levelStatuses,
      unitsCompleted: unitsCompleted ?? this.unitsCompleted,
      loggedIn: loggedIn ?? this.loggedIn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'grade': grade,
      'exp': exp,
      'studyMinutes': studyMinutes,
      'studyDate': studyDate,
      'levelStatuses': levelStatuses.map((e) => e.name).toList(),
      'unitsCompleted': unitsCompleted,
      'loggedIn': loggedIn,
    };
  }

  factory UserState.fromJson(Map<String, dynamic> json) {
    return UserState(
      name: json['name'] ?? '',
      grade: json['grade'] ?? '',
      exp: json['exp'] ?? 0,
      studyMinutes: json['studyMinutes'] ?? 0,
      studyDate: json['studyDate'],
      levelStatuses: (json['levelStatuses'] as List?)
          ?.map((e) => LevelStatus.values.firstWhere((v) => v.name == e))
          .toList(),
      unitsCompleted: (json['unitsCompleted'] as List?)
          ?.map((e) => List<int>.from(e))
          .toList(),
      loggedIn: json['loggedIn'] ?? false,
    );
  }
}

class StoreProvider with ChangeNotifier {
  final SharedPreferences prefs;
  UserState _user = UserState();
  String _currentRoute = '/';

  StoreProvider(this.prefs);

  UserState get user => _user;
  String get currentRoute => _currentRoute;

  void setRoute(String route) {
    _currentRoute = route;
    notifyListeners();
  }

  void loadFromStorage() {
    final raw = prefs.getString('mes_user');
    if (raw != null) {
      try {
        final parsed = UserState.fromJson(jsonDecode(raw));
        if (parsed.studyDate != UserState._todayStr()) {
          _user = parsed.copyWith(
            studyDate: UserState._todayStr(),
            studyMinutes: 0,
          );
        } else {
          _user = parsed;
        }
      } catch (e) {
        // Keep default state
      }
    }
    notifyListeners();
  }

  void _persist(UserState u) {
    _user = u;
    prefs.setString('mes_user', jsonEncode(u.toJson()));
    notifyListeners();
  }

  void login(String name, String grade) {
    _persist(_user.copyWith(name: name, grade: grade, loggedIn: true));
  }

  void logout() {
    _persist(UserState());
    prefs.remove('mes_user');
  }

  void addExp(int amount) {
    _persist(_user.copyWith(exp: _user.exp + amount));
  }

  void addStudyMinutes(int m) {
    _persist(_user.copyWith(
      studyMinutes: _user.studyMinutes + m,
      studyDate: UserState._todayStr(),
    ));
  }

  void setLevelStatus(int idx, LevelStatus s) {
    final arr = List<LevelStatus>.from(_user.levelStatuses);
    arr[idx] = s;
    if (s == LevelStatus.completed && idx + 1 < arr.length && arr[idx + 1] == LevelStatus.locked) {
      arr[idx + 1] = LevelStatus.unlocked;
    }
    _persist(_user.copyWith(levelStatuses: arr));
  }

  void completeModule(int level, int unit) {
    final grid = _user.unitsCompleted.map((row) => List<int>.from(row)).toList();
    if (grid[level][unit] < 3) {
      grid[level][unit] += 1;
    }
    _persist(_user.copyWith(unitsCompleted: grid));
  }

  void setPlacementLevel(int level) {
    final arr = List<LevelStatus>.filled(5, LevelStatus.locked);
    for (int i = 0; i < level; i++) {
      arr[i] = LevelStatus.completed;
    }
    arr[level] = LevelStatus.unlocked;
    _persist(_user.copyWith(levelStatuses: arr));
  }
}
