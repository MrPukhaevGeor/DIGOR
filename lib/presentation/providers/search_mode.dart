import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history.dart';

enum LanguageMode {
  digRussian,
  digEnglish,
  digTurkish,
  engDigor,
  rusDigor,
  turkDigor,
  engIron,
  rusIron,
  ironTurkish,
  ironEnglish,
  ironRussian,
  turkIron
}

class SearchModeNotifier extends StateNotifier<AsyncValue<LanguageMode>> {
  final Ref ref;
  late SharedPreferences sharedPreferences;

  SearchModeNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String langMode = sharedPreferences.getString('langMode') ?? 'digRussian';
    state = AsyncValue.data(_fromString(langMode));
  }

  LanguageMode _fromString(String value) {
    switch (value) {
      case 'digRussian':
        return LanguageMode.digRussian;
      case 'digEnglish':
        return LanguageMode.digEnglish;
      case 'digTurkish':
        return LanguageMode.digTurkish;
      case 'engDigor':
        return LanguageMode.engDigor;
      case 'rusDigor':
        return LanguageMode.rusDigor;
      case 'turkDigor':
        return LanguageMode.turkDigor;
      case 'ironRussian':
        return LanguageMode.ironRussian;
      case 'ironEnglish':
        return LanguageMode.ironEnglish;
      case 'ironTurkish':
        return LanguageMode.ironTurkish;
      case 'rusIron':
        return LanguageMode.rusIron;
      case 'engIron':
        return LanguageMode.engIron;
      case 'turkIron':
        return LanguageMode.turkIron;
      default:
        return LanguageMode.digRussian;
    }
  }

  Future<void> onDropDownFirstChange(String value) async {
    final toLanguage = getToLanguageMode();

    if (value == tr('iron')) {
      switch (toLanguage) {
        case 'en':
          state = const AsyncValue.data(LanguageMode.ironEnglish);
          await sharedPreferences.setString('langMode', 'ironEnglish');
        case 'ru':
          state = const AsyncValue.data(LanguageMode.ironRussian);
          await sharedPreferences.setString('langMode', 'ironRussian');

        case 'turk':
          state = const AsyncValue.data(LanguageMode.ironTurkish);
          await sharedPreferences.setString('langMode', ' ironTurkish');
      }
    }

    if (value == tr('digor')) {
      switch (toLanguage) {
        case 'en':
          state = const AsyncValue.data(LanguageMode.digEnglish);
          await sharedPreferences.setString('langMode', 'digEnglish');

        case 'ru':
          state = const AsyncValue.data(LanguageMode.digRussian);
          await sharedPreferences.setString('langMode', 'digRussian');

        case 'turk':
          state = const AsyncValue.data(LanguageMode.digTurkish);
          await sharedPreferences.setString('langMode', 'digTurkish');
      }
    }

    if (value == tr('russian')) {
      if (toLanguage == 'iron') {
        state = const AsyncValue.data(LanguageMode.rusIron);
        await sharedPreferences.setString('langMode', 'rusIron');
      }
      state = const AsyncValue.data(LanguageMode.rusDigor);
      sharedPreferences.setString('langMode', 'rusDigor');
    } else if (value == tr('english')) {
      if (toLanguage == 'iron') {
        state = const AsyncValue.data(LanguageMode.engIron);
        await sharedPreferences.setString('langMode', 'engIron');
      }
      state = const AsyncValue.data(LanguageMode.engDigor);
      sharedPreferences.setString('langMode', 'engDigor');
    } else if (value == tr('turkish')) {
      if (toLanguage == 'iron') {
        state = const AsyncValue.data(LanguageMode.turkIron);
        await sharedPreferences.setString('langMode', 'turkIron');
      }
      state = const AsyncValue.data(LanguageMode.turkDigor);
      await sharedPreferences.setString('langMode', 'turkDigor');
    }

    await ref.read(historyProvider.notifier).langModeUpdate();
  }

  Future<void> onDropDownSecondChange(String value) async {
    final fromLanguage = getFromLanguageMode();

    if (value == tr('iron')) {
      switch (fromLanguage) {
        case 'ru':
          state = const AsyncValue.data(LanguageMode.rusIron);
          await sharedPreferences.setString('langMode', 'rusIron');

        case 'en':
          state = const AsyncValue.data(LanguageMode.engIron);
          await sharedPreferences.setString('langMode', 'engIron');

        case 'turk':
          state = const AsyncValue.data(LanguageMode.turkIron);
          await sharedPreferences.setString('langMode', 'turkIron');
      }
    }

    if (value == tr('digor')) {
      switch (fromLanguage) {
        case 'ru':
          state = const AsyncValue.data(LanguageMode.rusDigor);
          await sharedPreferences.setString('langMode', 'rusDigor');

        case 'en':
          state = const AsyncValue.data(LanguageMode.engDigor);
          await sharedPreferences.setString('langMode', 'engDigor');

        case 'turk':
          state = const AsyncValue.data(LanguageMode.turkDigor);
          await sharedPreferences.setString('langMode', 'turkDigor');
      }
    }

    if (value == tr('russian')) {
      switch (fromLanguage) {
        case 'dig':
          state = const AsyncValue.data(LanguageMode.digRussian);
          await sharedPreferences.setString('langMode', 'digRussian');

        case 'iron':
          state = const AsyncValue.data(LanguageMode.ironRussian);
          await sharedPreferences.setString('langMode', 'ironRussian');

        default:
          state = const AsyncValue.data(LanguageMode.digRussian);
          await sharedPreferences.setString('langMode', 'digRussian');
      }
    }

    if (value == tr('english')) {
      switch (fromLanguage) {
        case 'dig':
          state = const AsyncValue.data(LanguageMode.digEnglish);
          await sharedPreferences.setString('langMode', 'digEnglish');

        case 'iron':
          state = const AsyncValue.data(LanguageMode.ironEnglish);
          await sharedPreferences.setString('langMode', 'ironEnglish');

        default:
          state = const AsyncValue.data(LanguageMode.digEnglish);
          await sharedPreferences.setString('langMode', 'digEnglish');
      }
    }

    if (value == tr('turkish')) {
      switch (fromLanguage) {
        case 'dig':
          state = const AsyncValue.data(LanguageMode.digTurkish);
          await sharedPreferences.setString('langMode', 'digTurkish');

        case 'iron':
          state = const AsyncValue.data(LanguageMode.ironTurkish);
          await sharedPreferences.setString('langMode', 'ironTurkish');

        default:
          state = const AsyncValue.data(LanguageMode.digTurkish);
          await sharedPreferences.setString('langMode', 'digTurkish');
      }
    }

    await ref.read(historyProvider.notifier).langModeUpdate();
  }

  Future<void> onSwitchLanguageTap() async {
    switch (state.value!) {
      case LanguageMode.digEnglish:
        state = const AsyncValue.data(LanguageMode.engDigor);
        await sharedPreferences.setString('langMode', 'engDigor');
        break;
      case LanguageMode.digRussian:
        state = const AsyncValue.data(LanguageMode.rusDigor);
        await sharedPreferences.setString('langMode', 'rusDigor');
        break;
      case LanguageMode.digTurkish:
        state = const AsyncValue.data(LanguageMode.turkDigor);
        await sharedPreferences.setString('langMode', 'turkDigor');
        break;
      case LanguageMode.engDigor:
        state = const AsyncValue.data(LanguageMode.digEnglish);
        await sharedPreferences.setString('langMode', 'digEnglish');
        break;
      case LanguageMode.rusDigor:
        state = const AsyncValue.data(LanguageMode.digRussian);
        await sharedPreferences.setString('langMode', 'digRussian');
        break;
      case LanguageMode.turkDigor:
        state = const AsyncValue.data(LanguageMode.digTurkish);
        await sharedPreferences.setString('langMode', 'digTurkish');
        break;
      case LanguageMode.engIron:
        state = const AsyncValue.data(LanguageMode.ironEnglish);
        await sharedPreferences.setString('langMode', 'ironEnglish');
      case LanguageMode.rusIron:
        state = const AsyncValue.data(LanguageMode.ironRussian);
        await sharedPreferences.setString('langMode', 'ironRussian');
      case LanguageMode.ironTurkish:
        state = const AsyncValue.data(LanguageMode.turkIron);
        await sharedPreferences.setString('langMode', 'turkIron');
      case LanguageMode.ironEnglish:
        state = const AsyncValue.data(LanguageMode.engIron);
        await sharedPreferences.setString('langMode', 'engIron');
      case LanguageMode.ironRussian:
        state = const AsyncValue.data(LanguageMode.rusIron);
        await sharedPreferences.setString('langMode', 'rusIron');
      case LanguageMode.turkIron:
        state = const AsyncValue.data(LanguageMode.ironTurkish);
        sharedPreferences.setString('langMode', 'ironTurkish');
    }
    ref.read(historyProvider.notifier).langModeUpdate();
  }

  String getFullLanguageMode() {
    switch (state.value) {
      case LanguageMode.digEnglish:
        return 'Dig-En';
      case LanguageMode.engDigor:
        return 'En-Dig';
      case LanguageMode.digRussian:
        return 'Dig-Ru';
      case LanguageMode.rusDigor:
        return 'Ru-Dig';
      case LanguageMode.digTurkish:
        return 'Dig-Turk';
      case LanguageMode.turkDigor:
        return 'Turk-Dig';
      case LanguageMode.engIron:
        return 'En-Iron';
      case LanguageMode.rusIron:
        return 'Ru-Iron';
      case LanguageMode.ironTurkish:
        return 'Iron-Turk';
      case LanguageMode.ironEnglish:
        return 'Iron-En';
      case LanguageMode.ironRussian:
        return 'Iron-Ru';
      case LanguageMode.turkIron:
        return 'Turk-Iron';
      default:
        return 'Dig-Ru';
    }
  }

  String getFromLanguageMode() {
    switch (state.value) {
      case LanguageMode.digEnglish:
        return 'dig';
      case LanguageMode.engDigor:
        return 'en';
      case LanguageMode.digRussian:
        return 'dig';
      case LanguageMode.rusDigor:
        return 'ru';
      case LanguageMode.digTurkish:
        return 'dig';
      case LanguageMode.turkDigor:
      case LanguageMode.engIron:
        return 'en';
      case LanguageMode.rusIron:
        return 'ru';
      case LanguageMode.ironTurkish:
        return 'iron';
      case LanguageMode.ironEnglish:
        return 'iron';
      case LanguageMode.ironRussian:
        return 'iron';
      case LanguageMode.turkIron:
        return 'turk';
      default:
        return 'dig';
    }
  }

  String getToLanguageMode() {
    switch (state.value) {
      case LanguageMode.digEnglish:
        return 'en';
      case LanguageMode.engDigor:
        return 'dig';
      case LanguageMode.digRussian:
        return 'ru';
      case LanguageMode.rusDigor:
        return 'dig';
      case LanguageMode.digTurkish:
        return 'turk';
      case LanguageMode.turkDigor:
        return 'dig';
      case LanguageMode.engIron:
        return 'iron';
      case LanguageMode.rusIron:
        return 'iron';
      case LanguageMode.ironTurkish:
        return 'turk';
      case LanguageMode.ironEnglish:
        return 'en';
      case LanguageMode.ironRussian:
        return 'ru';
      case LanguageMode.turkIron:
        return 'iron';
      default:
        return 'ru';
    }
  }
}

final searchModeProvider = StateNotifierProvider<SearchModeNotifier, AsyncValue<LanguageMode>>(
  (ref) {
    ref.keepAlive();
    return SearchModeNotifier(ref);
  },
  name: 'searchModeProvider',
);
