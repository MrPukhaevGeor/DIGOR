import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/data_sources/local/sqlite_datasource.dart';
import '../../../domain/models/word_model.dart';
import '../../providers/api_provider.dart';
import '../../providers/search_mode.dart';
import '../../providers/shared_pref.dart';

final fetchWordProvider = FutureProvider.family<WordModel?, int>((ref, id) async {
  final api = ref.read(localApiClientProvider);
  final from = ref.read(searchModeProvider.notifier).getFromLanguageMode();
  final to = ref.read(searchModeProvider.notifier).getToLanguageMode();

  return api.searchById(id, '$from=$to');
});

const String _articleZoomSettingKey = 'articleZoomSettingKey';

class ArticleZoomNotifier extends StateNotifier<double> {
  static const double _zoomChangeDifferens = .1;
  late final Future<SharedPreferences> _prefsFuture;

  ArticleZoomNotifier(this._prefsFuture) : super(1.0);

  Future<void> init() async {
    final prefs = await _prefsFuture;
    if (prefs.containsKey(_articleZoomSettingKey)) {
      state = prefs.getDouble(_articleZoomSettingKey) ?? 1.0;
    }
  }

  void incrementZoom() {
    state += _zoomChangeDifferens;
    _saveState();
  }

  void decrementZoom() {
    state -= _zoomChangeDifferens;
    _saveState();
  }

  Future<void> _saveState() async {
    final prefs = await _prefsFuture;
    prefs.setDouble(_articleZoomSettingKey, state);
  }
}

final articleZoomProvider = StateNotifierProvider<ArticleZoomNotifier, double>((ref) {
  final prefsFuture = ref.read(fetchSharedPreferencesProvider.future);
  return ArticleZoomNotifier(prefsFuture);
});

enum ExampleModeEnum { show, hide }

class ExampleModeNotifier extends StateNotifier<ExampleModeEnum> {
  ExampleModeNotifier() : super(ExampleModeEnum.show);

  void toggleExampleMode() => state = state == ExampleModeEnum.show ? ExampleModeEnum.hide : ExampleModeEnum.show;
}

final exampleModeProvider = StateNotifierProvider<ExampleModeNotifier, ExampleModeEnum>(
  (ref) => ExampleModeNotifier(),
);
