import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/data_sources/local/sqlite_datasource.dart';
import '../../domain/models/word_model.dart';
import 'api_provider.dart';
import 'search.dart';
import 'search_mode.dart';
import 'shared_pref.dart';

class HistoryNotifier extends AsyncNotifier<List<WordModel>> {
  late SQLiteDataSource _dataSource;
  late SharedPreferences _prefs;
  late String _savedLangMode;
  late String _savedWordsKey;

  @override
  Future<List<WordModel>> build() async {
    _dataSource = ref.read(localApiClientProvider);
    _prefs = await ref.read(fetchSharedPreferencesProvider.future);

    return await langModeUpdate();
  }

  Future<List<WordModel>> langModeUpdate() async {
    _savedLangMode = _prefs.getString('langMode') ?? 'digRussian';
    _savedWordsKey = _getKeyForLang(_savedLangMode);

    final savedIdsString = _prefs.getString(_savedWordsKey);
    if (savedIdsString == null || savedIdsString.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return [];
    }
    final ids = savedIdsString.split(';').where((e) => e.isNotEmpty).map(int.parse).toList();
    if (ids.isEmpty) {
      state = const AsyncValue.data([]);
      return [];
    }

    final fromLangMode = ref.read(searchModeProvider.notifier).getFromLanguageMode();
    final toLangMode = ref.read(searchModeProvider.notifier).getToLanguageMode();
    try {
      final response = await _dataSource.searchByIds(ids, '$fromLangMode=$toLangMode');
      state = AsyncValue.data(response);
      return response;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      return [];
    }
  }

  String _getKeyForLang(String langMode) {
    switch (langMode) {
      case 'digRussian':
        return 'digRusKey';
      case 'digEnglish':
        return 'digEngKey';
      case 'digTurkish':
        return 'digTurkishKey';
      case 'engDigor':
        return 'engDigorKey';
      case 'rusDigor':
        return 'rusDigorKey';
      case 'turkDigor':
        return 'turkDigorKey';
      case 'ironRussian':
        return 'ironRusKey';
      case 'rusIron':
        return 'rusIronKey';
      default:
        return 'digRusKey';
    }
  }

  Future<void> addWordToSaved(WordModel word) async {
    final words = [...?state.value];
    words.removeWhere((element) => element.id == word.id);
    debugPrint(_prefs.getString(_savedWordsKey));
    debugPrint(words.map((w) => w.id).join(';'));
    words.insert(0, word);
    state = AsyncValue.data(words);
    await _prefs.setString(_savedWordsKey, words.map((w) => w.id).join(';'));
  }

  Future<void> deleteFromHistory(WordModel word) async {
    final words = [...?state.value];
    words.removeWhere((element) => element.id == word.id);
    state = AsyncValue.data(words);
    await _prefs.setString(_savedWordsKey, words.map((w) => w.id).join(';'));
  }

  Future<void> clearHistory() async {
    state = const AsyncValue.data([]);
    await _prefs.setString(_savedWordsKey, '');
  }
}

final historyProvider = AsyncNotifierProvider<HistoryNotifier, List<WordModel>>(HistoryNotifier.new);
