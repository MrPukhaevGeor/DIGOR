import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_sources/local/sqlite_datasource.dart';
import '../../domain/models/word_model.dart';
import 'search_mode.dart';

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

    case LanguageMode.digRussian:
      fromLang = 'dig';
      toLang = 'ru';

    case LanguageMode.digTurkish:
      fromLang = 'dig';
      toLang = 'turk';

    case LanguageMode.engDigor:
      fromLang = 'en';
      toLang = 'dig';

    case LanguageMode.rusDigor:
      fromLang = 'ru';
      toLang = 'dig';

    case LanguageMode.turkDigor:
      fromLang = 'turk';
      toLang = 'dig';
    case LanguageMode.engIron:
      fromLang = 'en';
      toLang = 'iron';
    case LanguageMode.rusIron:
      fromLang = 'ru';
      toLang = 'iron';
    case LanguageMode.ironTurkish:
      fromLang = 'iron';
      toLang = 'turk';
    case LanguageMode.ironEnglish:
      fromLang = 'iron';
      toLang = 'en';
    case LanguageMode.ironRussian:
      fromLang = 'iron';
      toLang = 'ru';
    case LanguageMode.turkIron:
      fromLang = 'turk';
      toLang = 'iron';
  }

  final api = ref.watch(localApiClientProvider);
  final result = await api.search(text, fromLang, toLang);

  return result;
});
