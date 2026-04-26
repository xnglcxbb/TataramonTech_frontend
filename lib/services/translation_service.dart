import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

// ── Models ────────────────────────────────────────────────────────────────

class TranslationResult {
  final String input;
  final String output;
  final String direction;
  final String status;

  TranslationResult({
    required this.input,
    required this.output,
    required this.direction,
    required this.status,
  });

  factory TranslationResult.fromJson(Map<String, dynamic> json) {
    return TranslationResult(
      input: json['input'] ?? '',
      output: json['output'] ?? '',
      direction: json['direction'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class PosTag {
  final String word;
  final String pos;
  final List<String> tags;

  PosTag({required this.word, required this.pos, required this.tags});

  factory PosTag.fromJson(Map<String, dynamic> json) {
    return PosTag(
      word: json['word'] ?? '',
      pos: json['pos'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  // Human-readable POS label
  String get posLabel {
    switch (pos) {
      case 'n':
        return 'Noun';
      case 'v':
      case 'vblex':
        return 'Verb';
      case 'prn':
        return 'Pronoun';
      case 'adj':
        return 'Adjective';
      case 'adv':
        return 'Adverb';
      case 'pr':
        return 'Preposition';
      case 'det':
        return 'Determiner';
      default:
        return pos.toUpperCase();
    }
  }
}

class TranslationWithPos {
  final String input;
  final String output;
  final String direction;
  final List<PosTag> posTags;
  final String status;

  TranslationWithPos({
    required this.input,
    required this.output,
    required this.direction,
    required this.posTags,
    required this.status,
  });

  factory TranslationWithPos.fromJson(Map<String, dynamic> json) {
    return TranslationWithPos(
      input: json['input'] ?? '',
      output: json['output'] ?? '',
      direction: json['direction'] ?? '',
      posTags: (json['pos_tags'] as List<dynamic>? ?? [])
          .map((tag) => PosTag.fromJson(tag))
          .toList(),
      status: json['status'] ?? '',
    );
  }
}

class Phrase {
  final String english;
  final String bikol;

  Phrase({required this.english, required this.bikol});

  factory Phrase.fromJson(Map<String, dynamic> json) {
    return Phrase(
      english: json['english'] ?? '',
      bikol: json['bikol'] ?? '',
    );
  }
}

// ── Service ───────────────────────────────────────────────────────────────

class TranslationService {
  static const Duration _timeout = Duration(seconds: 10);

  // ── Check if server is alive ────────────────────────────────
  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.health))
          .timeout(_timeout);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ── Translate text ──────────────────────────────────────────
  static Future<TranslationResult> translate({
    required String text,
    required String direction, // 'eng-bcl' or 'bcl-eng'
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.translate).replace(
        queryParameters: {'text': text, 'direction': direction},
      );
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        return TranslationResult.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Translation failed: ${response.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ── Translate with POS tags ─────────────────────────────────
  static Future<TranslationWithPos> translateWithPos({
    required String text,
    required String direction,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.translatePos).replace(
        queryParameters: {'text': text, 'direction': direction},
      );
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        return TranslationWithPos.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Translation failed: ${response.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ── Get phrasebook ──────────────────────────────────────────
  static Future<Map<String, List<Phrase>>> getPhrasebook() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.phrasebook))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final phrases = data['phrases'] as Map<String, dynamic>;
        return phrases.map((category, items) {
          return MapEntry(
            category,
            (items as List).map((item) => Phrase.fromJson(item)).toList(),
          );
        });
      } else {
        throw Exception('Failed to load phrasebook');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ── Get phrasebook by category ──────────────────────────────
  static Future<List<Phrase>> getPhrasebookByCategory(String category) async {
    try {
      final uri = Uri.parse(ApiConfig.phrasebook).replace(
        queryParameters: {'category': category},
      );
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['phrases'] as List)
            .map((item) => Phrase.fromJson(item))
            .toList();
      } else {
        throw Exception('Category not found');
      }
    } on Exception catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ── Submit feedback ─────────────────────────────────────────
  static Future<bool> submitFeedback({
    required String inputText,
    required String translatedText,
    required String direction,
    required int rating,
    String comment = '',
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.feedback),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'input_text': inputText,
              'translated_text': translatedText,
              'direction': direction,
              'rating': rating,
              'comment': comment,
            }),
          )
          .timeout(_timeout);

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
