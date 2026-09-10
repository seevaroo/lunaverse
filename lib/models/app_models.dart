import 'package:flutter/material.dart';

enum UserRole { admin, user }

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
  final String id;
  final String email;
  final String name;
  final UserRole role;
}

class Language {
  const Language({
    required this.id,
    required this.name,
    required this.nativeName,
    required this.icon,
    required this.color,
    this.lessons = 12,
  });
  final String id;
  final String name;
  final String nativeName;
  final String icon;
  final Color color;
  final int lessons;
}

class Lesson {
  const Lesson({
    required this.title,
    required this.summary,
    required this.content,
    required this.languageId,
  });
  final String title;
  final String summary;
  final String content;
  final String languageId;
}

class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answerIndex,
  });
  final String question;
  final List<String> options;
  final int answerIndex;
}

class QuizAttempt {
  const QuizAttempt({
    required this.language,
    required this.score,
    required this.date,
  });
  final String language;
  final int score;
  final DateTime date;
}

class Certificate {
  const Certificate({required this.title, required this.issuedAt});
  final String title;
  final DateTime issuedAt;
}

class UserStreak {
  const UserStreak({required this.count, required this.lastActivityDate});
  final int count;
  final DateTime? lastActivityDate;
}
