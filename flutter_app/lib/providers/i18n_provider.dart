import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class I18nProvider with ChangeNotifier {
  final SharedPreferences prefs;
  String _lang = 'en';

  I18nProvider(this.prefs);

  String get lang => _lang;

  void setLang(String lang) {
    _lang = lang;
    prefs.setString('mes_lang', lang);
    notifyListeners();
  }

  void loadFromStorage() {
    final saved = prefs.getString('mes_lang');
    if (saved != null) {
      _lang = saved;
    }
  }

  String t(String key) {
    return _translations[key]?[_lang] ?? key;
  }

  static const Map<String, Map<String, String>> _translations = {
    'appName': {'en': 'Mongol English Spark', 'mn': 'Монгол Англи Очлол'},
    'login': {'en': 'Log in', 'mn': 'Нэвтрэх'},
    'signup': {'en': 'Sign up', 'mn': 'Бүртгүүлэх'},
    'logout': {'en': 'Log out', 'mn': 'Гарах'},
    'name': {'en': 'Name', 'mn': 'Нэр'},
    'grade': {'en': 'Grade', 'mn': 'Анги'},
    'email': {'en': 'Email', 'mn': 'И-мэйл'},
    'password': {'en': 'Password', 'mn': 'Нууц үг'},
    'continue': {'en': 'Continue', 'mn': 'Үргэлжлүүлэх'},
    'welcome': {'en': 'Welcome back', 'mn': 'Тавтай морил'},
    'startJourney': {'en': 'Start your English journey', 'mn': 'Англи хэлний аяллаа эхлүүлээрэй'},
    'home': {'en': 'Home', 'mn': 'Нүүр'},
    'grammar': {'en': 'Grammar', 'mn': 'Дүрэм'},
    'arcade': {'en': 'Arcade', 'mn': 'Тоглоом'},
    'account': {'en': 'Account', 'mn': 'Бүртгэл'},
    'placementTest': {'en': 'English Placement Test', 'mn': 'Англи хэлний түвшин тогтоох сорил'},
    'placementDesc': {'en': 'Take a 12-question diagnostic to find your level', 'mn': '12 асуултаар түвшингээ тогтоо'},
    'startTest': {'en': 'Start Test', 'mn': 'Сорил эхлүүлэх'},
    'dailyStudy': {'en': 'Daily Study Time', 'mn': 'Өдрийн суралцсан хугацаа'},
    'minutesToday': {'en': 'minutes today', 'mn': 'минут өнөөдөр'},
    'start': {'en': 'Start', 'mn': 'Эхлэх'},
    'pause': {'en': 'Pause', 'mn': 'Зогсоох'},
    'reset': {'en': 'Reset', 'mn': 'Шинэчлэх'},
    'levels': {'en': 'Learning Roadmap', 'mn': 'Сургалтын зам'},
    'level': {'en': 'Level', 'mn': 'Түвшин'},
    'unit': {'en': 'Unit', 'mn': 'Бүлэг'},
    'reading': {'en': 'Reading', 'mn': 'Уншлага'},
    'vocabulary': {'en': 'Vocabulary', 'mn': 'Үгсийн сан'},
    'locked': {'en': 'Locked', 'mn': 'Түгжээтэй'},
    'unlocked': {'en': 'Unlocked', 'mn': 'Нээлттэй'},
    'completed': {'en': 'Completed', 'mn': 'Дууссан'},
    'levelTest': {'en': 'Level Completion Test', 'mn': 'Түвшний шалгалт'},
    'exp': {'en': 'EXP', 'mn': 'Оноо'},
    'totalExp': {'en': 'Total EXP', 'mn': 'Нийт оноо'},
    'expRoom': {'en': 'EXP Trophy Room', 'mn': 'Шагналын танхим'},
    'progress': {'en': 'Progress', 'mn': 'Ахиц'},
    'language': {'en': 'Language', 'mn': 'Хэл'},
    'personalAccount': {'en': 'Personal Account', 'mn': 'Хувийн бүртгэл'},
    'grammarHub': {'en': 'Grammar Video & Practice Hub', 'mn': 'Дүрмийн видео ба дасгал'},
    'selectTopic': {'en': 'Select a grammar topic', 'mn': 'Дүрмийн сэдэв сонгоно уу'},
    'practiceQuiz': {'en': 'Practice Quiz', 'mn': 'Дасгал тест'},
    'submit': {'en': 'Submit', 'mn': 'Илгээх'},
    'next': {'en': 'Next', 'mn': 'Дараах'},
    'correct': {'en': 'Correct!', 'mn': 'Зөв!'},
    'incorrect': {'en': 'Try again', 'mn': 'Дахин оролд'},
    'arcadeTitle': {'en': 'Gamification Arcade', 'mn': 'Тоглоомын талбай'},
    'wordScramble': {'en': 'Word Scramble', 'mn': 'Үг эмхэтгэгч'},
    'wordPuzzle': {'en': 'Word Puzzle', 'mn': 'Үг таавар'},
    'syntaxBlaster': {'en': 'Syntax Blaster', 'mn': 'Дүрмийн сорил'},
    'scrambleDesc': {'en': 'Drag words to form a correct sentence', 'mn': 'Үгсийг чирж зөв өгүүлбэр зохио'},
    'puzzleDesc': {'en': 'Match words with their definitions', 'mn': 'Үгийг тодорхойлолттой нь тааруул'},
    'blasterDesc': {'en': 'Fast-paced grammar correction', 'mn': 'Хурдан дүрмийн засалт'},
    'play': {'en': 'Play', 'mn': 'Тоглох'},
    'finish': {'en': 'Finish', 'mn': 'Дуусгах'},
    'yourLevel': {'en': 'Your Level', 'mn': 'Таны түвшин'},
    'testScore': {'en': 'Your score', 'mn': 'Таны оноо'},
    'question': {'en': 'Question', 'mn': 'Асуулт'},
    'of': {'en': 'of', 'mn': '/'},
    'passed': {'en': 'Passed! Next level unlocked.', 'mn': 'Тэнцлээ! Дараагийн түвшин нээгдлээ.'},
    'failed': {'en': 'Not quite. Practice more and retry.', 'mn': 'Тэнцсэнгүй. Дахин оролдоорой.'},
    'greeting': {'en': 'Hi', 'mn': 'Сайн уу'},
    'tip': {'en': 'Tip', 'mn': 'Зөвлөгөө'},
    'back': {'en': 'Back', 'mn': 'Буцах'},
    'noAccount': {'en': "Don't have an account?", 'mn': 'Бүртгэлгүй юу?'},
    'haveAccount': {'en': 'Already have an account?', 'mn': 'Бүртгэлтэй юу?'},
  };
}
