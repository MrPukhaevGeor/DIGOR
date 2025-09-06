import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app.dart';
import '../../../outside_functions.dart';
import '../../providers/localization.dart';
import '../../providers/search_mode.dart';
import '../home_page/home_page_model.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('settings'),
          style: theme.textTheme.bodyMedium!.copyWith(
              color: Colors.white, fontSize: 21, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: Text(tr('common'),
                style:
                    theme.textTheme.bodyMedium!.copyWith(color: Colors.blue)),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
            child: ListTile(
              title: Text(tr('language'),
                  style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
              onTap: () async {
                final theme = Theme.of(context);
                final LocalizationLanguage result = await showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: EdgeInsets.all(26),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0))),
                        child: Consumer(builder: (context, ref, child) {
                          final currentLocalizationMode =
                              ref.watch(localizationModeProvider);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 16),
                                child: Text(tr('language'),
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(fontSize: 16)),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.only(left: 8),
                                onTap: () {
                                  ref
                                      .read(localizationModeProvider.notifier)
                                      .onChangeLocale(
                                          LocalizationLanguage.system);
                                  Navigator.of(context)
                                      .pop(LocalizationLanguage.system);
                                },
                                leading: Radio(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Colors.blue; // Выделенный - синий
                                    }
                                    return Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.blue
                                        : Colors.black; // Невыделенный - черный
                                  }),
                                  groupValue: currentLocalizationMode,
                                  value: LocalizationLanguage.system,
                                  onChanged: (value) {
                                    ref
                                        .read(localizationModeProvider.notifier)
                                        .onChangeLocale(value!);
                                    Navigator.of(context)
                                        .pop(LocalizationLanguage.system);
                                  },
                                ),
                                title: Text(
                                  tr('system'),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 18),
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.only(left: 8),
                                onTap: () {
                                  ref
                                      .read(localizationModeProvider.notifier)
                                      .onChangeLocale(
                                          LocalizationLanguage.digor);
                                  Navigator.of(context)
                                      .pop(LocalizationLanguage.digor);
                                },
                                leading: Radio(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Colors.blue; // Выделенный - синий
                                    }
                                    return Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.blue
                                        : Colors.black; // Невыделенный - черный
                                  }),
                                  groupValue: currentLocalizationMode,
                                  value: LocalizationLanguage.digor,
                                  onChanged: (value) {
                                    ref
                                        .read(localizationModeProvider.notifier)
                                        .onChangeLocale(value!);
                                    Navigator.of(context)
                                        .pop(LocalizationLanguage.digor);
                                  },
                                ),
                                title: Text(
                                  tr('digor'),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 18),
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.only(left: 8),
                                onTap: () {
                                  ref
                                      .read(localizationModeProvider.notifier)
                                      .onChangeLocale(
                                          LocalizationLanguage.iron);
                                  Navigator.of(context)
                                      .pop(LocalizationLanguage.iron);
                                },
                                leading: Radio(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Colors.blue; // Выделенный - синий
                                    }
                                    return Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.blue
                                        : Colors.black; // Невыделенный - черный
                                  }),
                                  groupValue: currentLocalizationMode,
                                  value: LocalizationLanguage.iron,
                                  onChanged: (value) {
                                    ref
                                        .read(localizationModeProvider.notifier)
                                        .onChangeLocale(value!);
                                    Navigator.of(context)
                                        .pop(LocalizationLanguage.iron);
                                  },
                                ),
                                title: Text(
                                  tr('iron'),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 18),
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.only(left: 8),
                                onTap: () {
                                  final searchMode =
                                      ref.read(searchModeProvider).value;
                                  if ([
                                    LanguageMode.digEnglish,
                                    LanguageMode.digRussian,
                                    LanguageMode.digTurkish
                                  ].contains(searchMode)) {
                                    ref
                                        .read(searchModeProvider.notifier)
                                        .onDropDownSecondChange(tr('russian'));
                                  } else {
                                    ref
                                        .read(searchModeProvider.notifier)
                                        .onDropDownFirstChange(tr('russian'));
                                  }
                                  ref
                                      .read(localizationModeProvider.notifier)
                                      .onChangeLocale(
                                          LocalizationLanguage.russian);
                                  Navigator.of(context)
                                      .pop(LocalizationLanguage.russian);
                                },
                                leading: Radio(
                                  groupValue: currentLocalizationMode,
                                  value: LocalizationLanguage.russian,
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Colors.blue; // Выделенный - синий
                                    }
                                    return Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.blue
                                        : Colors.black; // Невыделенный - черный
                                  }),
                                  onChanged: (value) {
                                    final searchMode =
                                        ref.read(searchModeProvider).value;
                                    if ([
                                      LanguageMode.digEnglish,
                                      LanguageMode.digRussian,
                                      LanguageMode.digTurkish
                                    ].contains(searchMode)) {
                                      ref
                                          .read(searchModeProvider.notifier)
                                          .onDropDownSecondChange(
                                              tr('russian'));
                                    } else {
                                      ref
                                          .read(searchModeProvider.notifier)
                                          .onDropDownFirstChange(tr('russian'));
                                    }
                                    ref
                                        .read(localizationModeProvider.notifier)
                                        .onChangeLocale(value!);
                                    Navigator.of(context)
                                        .pop(LocalizationLanguage.russian);
                                  },
                                ),
                                title: Text(
                                  tr('russian'),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 18),
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.only(left: 8),
                                onTap: () {
                                  final searchMode =
                                      ref.read(searchModeProvider).value;
                                  if ([
                                    LanguageMode.digEnglish,
                                    LanguageMode.digRussian,
                                    LanguageMode.digTurkish
                                  ].contains(searchMode)) {
                                    ref
                                        .read(searchModeProvider.notifier)
                                        .onDropDownSecondChange(tr('english'));
                                  } else {
                                    ref
                                        .read(searchModeProvider.notifier)
                                        .onDropDownFirstChange(tr('english'));
                                  }
                                  ref
                                      .read(localizationModeProvider.notifier)
                                      .onChangeLocale(
                                          LocalizationLanguage.english);
                                  Navigator.of(context)
                                      .pop(LocalizationLanguage.english);
                                },
                                leading: Radio(
                                  groupValue: currentLocalizationMode,
                                  value: LocalizationLanguage.english,
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Colors.blue; // Выделенный - синий
                                    }
                                    return Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.blue
                                        : Colors.black; // Невыделенный - черный
                                  }),
                                  onChanged: (value) {
                                    final searchMode =
                                        ref.read(searchModeProvider).value;
                                    if ([
                                      LanguageMode.digEnglish,
                                      LanguageMode.digRussian,
                                      LanguageMode.digTurkish
                                    ].contains(searchMode)) {
                                      ref
                                          .read(searchModeProvider.notifier)
                                          .onDropDownSecondChange(
                                              tr('english'));
                                    } else {
                                      ref
                                          .read(searchModeProvider.notifier)
                                          .onDropDownFirstChange(tr('english'));
                                    }
                                    ref
                                        .read(localizationModeProvider.notifier)
                                        .onChangeLocale(value!);
                                    Navigator.of(context)
                                        .pop(LocalizationLanguage.english);
                                  },
                                ),
                                title: Text(
                                  tr('english'),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 18),
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.only(left: 8),
                                onTap: () {
                                  final searchMode =
                                      ref.read(searchModeProvider).value;
                                  if ([
                                    LanguageMode.digEnglish,
                                    LanguageMode.digRussian,
                                    LanguageMode.digTurkish
                                  ].contains(searchMode)) {
                                    ref
                                        .read(searchModeProvider.notifier)
                                        .onDropDownSecondChange(tr('english'));
                                  } else {
                                    ref
                                        .read(searchModeProvider.notifier)
                                        .onDropDownFirstChange(tr('english'));
                                  }
                                  ref
                                      .read(localizationModeProvider.notifier)
                                      .onChangeLocale(
                                          LocalizationLanguage.turkish);
                                  Navigator.of(context)
                                      .pop(LocalizationLanguage.turkish);
                                },
                                leading: Radio(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Colors.blue; // Выделенный - синий
                                    }
                                    return Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.blue
                                        : Colors.black; // Невыделенный - черный
                                  }),
                                  groupValue: currentLocalizationMode,
                                  value: LocalizationLanguage.turkish,
                                  onChanged: (value) {
                                    final searchMode =
                                        ref.read(searchModeProvider).value;
                                    if ([
                                      LanguageMode.digEnglish,
                                      LanguageMode.digRussian,
                                      LanguageMode.digTurkish
                                    ].contains(searchMode)) {
                                      ref
                                          .read(searchModeProvider.notifier)
                                          .onDropDownSecondChange(
                                              tr('english'));
                                    } else {
                                      ref
                                          .read(searchModeProvider.notifier)
                                          .onDropDownFirstChange(tr('english'));
                                    }
                                    ref
                                        .read(localizationModeProvider.notifier)
                                        .onChangeLocale(value!);
                                    Navigator.of(context)
                                        .pop(LocalizationLanguage.turkish);
                                  },
                                ),
                                title: Text(
                                  tr('turkish'),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(),
                                        child: Text(tr('cancel').toUpperCase(),
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.blue)))
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                      );
                    });
                await Future.delayed(const Duration(milliseconds: 200));

                switch (result) {
                  case LocalizationLanguage.system:
                    context.resetLocale();
                  case LocalizationLanguage.russian:
                    context.setLocale(const Locale('ru', 'RU'));
                  case LocalizationLanguage.english:
                    context.setLocale(const Locale('en', 'US'));
                  case LocalizationLanguage.turkish:
                    context.setLocale(const Locale('tr', 'TR'));
                  case LocalizationLanguage.digor:
                    context.setLocale(const Locale('de', 'DE'));
                  case LocalizationLanguage.iron:
                    context.setLocale(const Locale('uz', 'UZ'));
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
            child: ListTile(
                title: Text(tr('theme'),
                    style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: EdgeInsets.all(26),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0))),
                        child: Consumer(builder: (context, ref, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 16, bottom: 8),
                                child: Text(
                                  tr('theme'),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 20),
                                ),
                              ),
                              ListTile(
                                visualDensity:
                                    const VisualDensity(vertical: -.3),
                                contentPadding: const EdgeInsets.only(left: 8),
                                onTap: () {
                                  if (theme.brightness == Brightness.dark)
                                    AdaptiveTheme.of(context).setLight();
                                  Navigator.of(context).pop();
                                },
                                leading: Radio(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Colors.blue; // Выделенный - синий
                                    }
                                    return Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.blue
                                        : Colors.black; // Невыделенный - черный
                                  }),
                                  groupValue: theme.brightness,
                                  value: Brightness.light,
                                  onChanged: (value) {
                                    if (theme.brightness == Brightness.dark)
                                      AdaptiveTheme.of(context).setLight();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                title: Text(
                                  tr('light_theme'),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 18),
                                ),
                              ),
                              ListTile(
                                visualDensity:
                                    const VisualDensity(vertical: -.3),
                                contentPadding: const EdgeInsets.only(left: 8),
                                onTap: () {
                                  if (theme.brightness == Brightness.light)
                                    AdaptiveTheme.of(context).setDark();
                                  Navigator.of(context).pop();
                                },
                                leading: Radio(
                                  groupValue: theme.brightness,
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Colors.blue; // Выделенный - синий
                                    }
                                    return Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.blue
                                        : Colors.black; // Невыделенный - черный
                                  }),
                                  value: Brightness.dark,
                                  onChanged: (value) {
                                    if (theme.brightness == Brightness.light)
                                      AdaptiveTheme.of(context).setDark();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                title: Text(
                                  tr('dark_theme'),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(),
                                        child: Text(tr('cancel').toUpperCase(),
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.blue)))
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                      );
                    })),
          ),
          ListTile(
            onTap: () {
              ref.read(splitModeProvider.notifier).newState =
                  !ref.read(splitModeProvider.notifier).state;
            },
            visualDensity: const VisualDensity(vertical: 4),
            title: Text(
              tr('split_screen'),
              style: theme.textTheme.bodyMedium!.copyWith(
                fontSize: 17,
              ),
              softWrap: false,
              maxLines: 2,
            ),
            subtitle: Text(
              tr('split_screen_subtitle'),
              style: theme.textTheme.bodyMedium!.copyWith(
                fontSize: 15,
              ),
              maxLines: 3,
            ),
            trailing: Checkbox(
              overlayColor: WidgetStateProperty.all(Colors.white),
              side: BorderSide(color: Colors.black, width: 2),
              value: ref.watch(splitModeProvider),
              onChanged: (value) =>
                  ref.read(splitModeProvider.notifier).newState = value!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: Text(tr('glossary'),
                style:
                    theme.textTheme.bodyMedium!.copyWith(color: Colors.blue)),
          ),
          ListTile(
              visualDensity: const VisualDensity(vertical: -.3),
              title: Text(tr('font_size'),
                  style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
              onTap: () => showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      insetPadding: EdgeInsets.all(26),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.0))),
                      child: Consumer(builder: (context, ref, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 16, bottom: 8),
                              child: Text(tr('font_size'),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 20)),
                            ),
                            ListTile(
                              visualDensity: const VisualDensity(vertical: -.3),
                              contentPadding: const EdgeInsets.only(left: 8),
                              onTap: () {
                                ref
                                    .read(glossaryZoomProvider.notifier)
                                    .newState = GlossaryZoomState.little;
                                Navigator.of(context).pop();
                              },
                              leading: Radio(
                                groupValue: ref.watch(glossaryZoomProvider),
                                value: .9,
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.blue; // Выделенный - синий
                                  }
                                  return Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.blue
                                      : Colors.black; // Невыделенный - черный
                                }),
                                onChanged: (value) {
                                  ref
                                      .read(glossaryZoomProvider.notifier)
                                      .newState = GlossaryZoomState.little;
                                  Navigator.of(context).pop();
                                },
                              ),
                              title: Text(
                                tr('little'),
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            ListTile(
                              visualDensity: const VisualDensity(vertical: -.3),
                              contentPadding: const EdgeInsets.only(left: 8),
                              onTap: () {
                                ref
                                    .read(glossaryZoomProvider.notifier)
                                    .newState = GlossaryZoomState.normal;
                                Navigator.of(context).pop();
                              },
                              leading: Radio(
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.blue; // Выделенный - синий
                                  }
                                  return Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.blue
                                      : Colors.black; // Невыделенный - черный
                                }),
                                groupValue: ref.watch(glossaryZoomProvider),
                                value: 1,
                                onChanged: (value) {
                                  ref
                                      .read(glossaryZoomProvider.notifier)
                                      .newState = GlossaryZoomState.normal;
                                  Navigator.of(context).pop();
                                },
                              ),
                              title: Text(
                                tr('normal'),
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                            ListTile(
                              visualDensity: const VisualDensity(vertical: -.3),
                              contentPadding: const EdgeInsets.only(left: 8),
                              onTap: () {
                                ref
                                    .read(glossaryZoomProvider.notifier)
                                    .newState = GlossaryZoomState.big;
                                Navigator.of(context).pop();
                              },
                              leading: Radio(
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.blue; // Выделенный - синий
                                  }
                                  return Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.blue
                                      : Colors.black; // Невыделенный - черный
                                }),
                                groupValue: ref.watch(glossaryZoomProvider),
                                value: 1.1,
                                onChanged: (value) {
                                  ref
                                      .read(glossaryZoomProvider.notifier)
                                      .newState = GlossaryZoomState.big;
                                  Navigator.of(context).pop();
                                },
                              ),
                              title: Text(
                                tr('big'),
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () => Navigator.of(context,
                                              rootNavigator: true)
                                          .pop(),
                                      child: Text(tr('cancel').toUpperCase(),
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(color: Colors.blue)))
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                    );
                  })),
        ],
      ),
    );
  }
}
