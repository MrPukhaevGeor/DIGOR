import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/db_helper.dart';
import '../../data/data_sources/local/sqlite_datasource.dart';
import '../../domain/models/word_model.dart';
import 'search_mode.dart';

// Асинхронный провайдер для поиска
final searchProvider = FutureProvider.family<List<WordModel>, String>((ref, text) async {
  if (text.trim().isEmpty) {
    return [];
  }
  final mode = ref.watch(searchModeProvider).value;
  if (mode == null) return [];
  String fromLang = '';
  String toLang = '';
  switch (mode) {
    case LanguageMode.digEnglish:
      fromLang = 'dig';
      toLang = 'en';
      break;
    case LanguageMode.digRussian:
      fromLang = 'dig';
      toLang = 'ru';
      break;
    case LanguageMode.digTurkish:
      fromLang = 'dig';
      toLang = 'turk';
      break;
    case LanguageMode.engDigor:
      fromLang = 'en';
      toLang = 'dig';
      break;
    case LanguageMode.rusDigor:
      fromLang = 'ru';
      toLang = 'dig';
      break;
    case LanguageMode.turkDigor:
      fromLang = 'turk';
      toLang = 'dig';
      break;
  }

  final api = ref.watch(localApiClientProvider);
  final result = await api.search(text, fromLang, toLang);

  return result;
});
