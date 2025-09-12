import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_sources/local/sqlite_datasource.dart';
import '../../domain/models/word_model.dart';
import 'search_mode.dart';

const _dir = <LanguageMode, (String from, String to)>{
  LanguageMode.digEnglish: ('dig', 'en'),
  LanguageMode.digRussian: ('dig', 'ru'),
  LanguageMode.digTurkish: ('dig', 'turk'),
  LanguageMode.engDigor: ('en', 'dig'),
  LanguageMode.rusDigor: ('ru', 'dig'),
  LanguageMode.turkDigor: ('turk', 'dig'),
  LanguageMode.engIron: ('en', 'iron'),
  LanguageMode.rusIron: ('ru', 'iron'),
  LanguageMode.ironTurkish: ('iron', 'turk'),
  LanguageMode.ironEnglish: ('iron', 'en'),
  LanguageMode.ironRussian: ('iron', 'ru'),
  LanguageMode.turkIron: ('turk', 'iron'),
};

final searchProvider = FutureProvider.family<List<WordModel>, String>((ref, text) async {
  if (text.trim().isEmpty) return [];

  final mode = ref.watch(searchModeProvider).value;
  if (mode == null) return [];
  final (fromLang, toLang) = _dir[mode]!;
  final api = ref.watch(localApiClientProvider);
  final result = await api.search(text, fromLang, toLang);
   return result;
 });
