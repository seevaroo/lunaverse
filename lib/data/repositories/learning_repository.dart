import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/app_models.dart';

abstract class LearningRepository {
  Future<List<Language>> getLanguages();
  Future<List<Lesson>> getLessons(String languageId);
  Future<List<QuizQuestion>> getQuiz(String languageId);
  Future<List<QuizAttempt>> getAttempts(String userId);
  Future<List<Certificate>> getCertificates(String userId);
  Future<void> saveAttempt(String userId, QuizAttempt attempt);
  Future<UserStreak> getStreak(String userId);
  Future<UserStreak> saveStreak(String userId, UserStreak streak);
}

class SupabaseLearningRepository implements LearningRepository {
  final _client = Supabase.instance.client;
  @override
  Future<List<Language>> getLanguages() async =>
      (await _client.from('languages').select())
          .map(
            (row) => Language(
              id: row['id'],
              name: row['name'],
              nativeName: row['native_name'] ?? row['name'],
              icon: row['icon'] ?? '🌐',
              color: const Color(0xff3155d9),
              lessons: row['lesson_count'] ?? 0,
            ),
          )
          .toList();
  @override
  Future<List<Lesson>> getLessons(String languageId) async =>
      (await _client.from('lessons').select().eq('language_id', languageId))
          .map(
            (row) => Lesson(
              title: row['title'],
              summary: row['summary'] ?? '',
              content: row['content'] ?? '',
              languageId: languageId,
            ),
          )
          .toList();
  @override
  Future<List<QuizQuestion>> getQuiz(String languageId) async =>
      (await _client
              .from('quiz_questions')
              .select()
              .eq('language_id', languageId))
          .map(
            (row) => QuizQuestion(
              question: row['question'],
              options: List<String>.from(row['options']),
              answerIndex: row['answer_index'],
            ),
          )
          .toList();
  @override
  Future<List<QuizAttempt>> getAttempts(String userId) async =>
      (await _client.from('quiz_attempts').select().eq('user_id', userId))
          .map(
            (row) => QuizAttempt(
              language: row['language'] ?? '',
              score: row['score'],
              date: DateTime.parse(row['created_at']),
            ),
          )
          .toList();
  @override
  Future<List<Certificate>> getCertificates(String userId) async =>
      (await _client.from('certificates').select().eq('user_id', userId))
          .map(
            (row) => Certificate(
              title: row['title'],
              issuedAt: DateTime.parse(row['issued_at']),
            ),
          )
          .toList();
  @override
  Future<void> saveAttempt(String userId, QuizAttempt attempt) =>
      _client.from('quiz_attempts').insert({
        'user_id': userId,
        'language': attempt.language,
        'score': attempt.score,
      });
  @override
  Future<UserStreak> getStreak(String userId) async {
    final row = await _client
        .from('user_streaks')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (row == null) return const UserStreak(count: 0, lastActivityDate: null);
    return UserStreak(
      count: row['streak_count'] as int,
      lastActivityDate: DateTime.tryParse(row['last_activity_date'] as String),
    );
  }

  @override
  Future<UserStreak> saveStreak(String userId, UserStreak streak) async {
    final row = await _client
        .from('user_streaks')
        .upsert({
          'user_id': userId,
          'streak_count': streak.count,
          'last_activity_date': streak.lastActivityDate
              ?.toIso8601String()
              .substring(0, 10),
        })
        .select()
        .single();
    return UserStreak(
      count: row['streak_count'] as int,
      lastActivityDate: DateTime.tryParse(row['last_activity_date'] as String),
    );
  }
}

class DemoLearningRepository implements LearningRepository {
  DemoLearningRepository();
  static const languages = [
    Language(
      id: 'en',
      name: 'English',
      nativeName: 'English',
      icon: '🇬🇧',
      color: Color(0xff3155d9),
    ),
    Language(
      id: 'ja',
      name: 'Japanese',
      nativeName: '日本語',
      icon: '🇯🇵',
      color: Color(0xffdb4560),
    ),
    Language(
      id: 'es',
      name: 'Spanish',
      nativeName: 'Español',
      icon: '🇪🇸',
      color: Color(0xffe59d32),
    ),
    Language(
      id: 'zh',
      name: 'Chinese',
      nativeName: '中文',
      icon: '🇨🇳',
      color: Color(0xffb73645),
    ),
    Language(
      id: 'ko',
      name: 'Korean',
      nativeName: '한국어',
      icon: '🇰🇷',
      color: Color(0xff5b63c7),
    ),
  ];
  static const questions = [
    QuizQuestion(
      question: 'What does “hello” mean?',
      options: ['Halo', 'Selamat tinggal', 'Terima kasih'],
      answerIndex: 0,
    ),
    QuizQuestion(
      question: 'Choose the correct sentence.',
      options: ['I am learn.', 'I am learning.', 'I learning am.'],
      answerIndex: 1,
    ),
    QuizQuestion(
      question: 'What is the plural of “book”?',
      options: ['Bookes', 'Books', 'Book'],
      answerIndex: 1,
    ),
  ];
  final Map<String, List<QuizAttempt>> _attempts = {};
  @override
  Future<List<Language>> getLanguages() async => languages;
  @override
  Future<List<Lesson>> getLessons(String id) async => [
    Lesson(
      title: 'First steps',
      summary: 'Sapaan dan frasa dasar untuk memulai.',
      content:
          'Mulai dengan sapaan sederhana. Dengarkan, tirukan, lalu gunakan dalam percakapan singkat.',
      languageId: id,
    ),
    Lesson(
      title: 'Daily phrases',
      summary: 'Kosakata yang sering digunakan setiap hari.',
      content:
          'Pelajari frasa praktis dan susun menjadi kalimat pendek yang bermakna.',
      languageId: id,
    ),
  ];
  @override
  Future<List<QuizQuestion>> getQuiz(String languageId) async => questions;
  @override
  Future<List<QuizAttempt>> getAttempts(String userId) async =>
      _attempts[userId] ?? const [];
  @override
  Future<List<Certificate>> getCertificates(String userId) async => const [];
  @override
  Future<void> saveAttempt(String userId, QuizAttempt attempt) async =>
      (_attempts[userId] ??= []).insert(0, attempt);
  final Map<String, UserStreak> _streaks = {};
  @override
  Future<UserStreak> getStreak(String userId) async =>
      _streaks[userId] ?? const UserStreak(count: 0, lastActivityDate: null);
  @override
  Future<UserStreak> saveStreak(String userId, UserStreak streak) async =>
      _streaks[userId] = streak;
}
