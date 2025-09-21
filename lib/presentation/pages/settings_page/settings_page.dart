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
    final isBold = MediaQuery.of(context).boldText;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0), boldText: false),
          child: Text(
            tr('settings'),
            style: theme.textTheme.bodyMedium!.copyWith(
              color: Colors.white,
              fontSize: 22,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
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

          // Language selector row
          Container(
          
            child: ListTile(
              title: Text(tr('language'),
                  style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
              onTap: () async {
                final theme = Theme.of(context);
                final LocalizationLanguage? result = await showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      insetPadding: EdgeInsets.all(26),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.0))),
                      child: Consumer(builder: (context, ref, child) {
                        final currentLocalizationMode =
                            ref.watch(localizationModeProvider);

                        // Helper that matches the structure you provided
                        Widget radioListTileLike<T>({
                          required T value,
                          required T groupValue,
                          required VoidCallback onTap,
                          required String label,
                          double labelFontSize = 18,
                        }) {
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onTap,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Radio<T>(
                                      fillColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return Colors.blue; // selected
                                        }
                                        return Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.blue
                                            : Colors.black; // unselected
                                      }),
                                      groupValue: groupValue,
                                      value: value,
                                      onChanged: (_) => onTap(),
                                    ),
                                  ),
                                  Flexible(
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.only(
                                          left: 8, right: 24),
                                      title: Text(
                                        label,
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(fontSize: labelFontSize),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, top: 16, bottom: 8),
                              child: Text(tr('language'),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 20)),
                            ),

                            // system (uses your provided large font example)
                            radioListTileLike<LocalizationLanguage>(
                              value: LocalizationLanguage.system,
                              groupValue: currentLocalizationMode,
                              label: tr('system'),
                              labelFontSize: 18,
                              onTap: () {
                                ref
                                    .read(localizationModeProvider.notifier)
                                    .onChangeLocale(
                                        LocalizationLanguage.system);
                                Navigator.of(context)
                                    .pop(LocalizationLanguage.system);
                              },
                            ),

                            // digor
                            radioListTileLike<LocalizationLanguage>(
                              value: LocalizationLanguage.digor,
                              groupValue: currentLocalizationMode,
                              label: tr('digor'),
                              onTap: () {
                                ref
                                    .read(localizationModeProvider.notifier)
                                    .onChangeLocale(LocalizationLanguage.digor);
                                Navigator.of(context)
                                    .pop(LocalizationLanguage.digor);
                              },
                            ),

                            // iron
                            radioListTileLike<LocalizationLanguage>(
                              value: LocalizationLanguage.iron,
                              groupValue: currentLocalizationMode,
                              label: tr('iron'),
                              onTap: () {
                                ref
                                    .read(localizationModeProvider.notifier)
                                    .onChangeLocale(LocalizationLanguage.iron);
                                Navigator.of(context)
                                    .pop(LocalizationLanguage.iron);
                              },
                            ),

                            // russian (keeps searchMode logic)
                            radioListTileLike<LocalizationLanguage>(
                              value: LocalizationLanguage.russian,
                              groupValue: currentLocalizationMode,
                              label: tr('russian'),
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
                            ),

                            // english
                            radioListTileLike<LocalizationLanguage>(
                              value: LocalizationLanguage.english,
                              groupValue: currentLocalizationMode,
                              label: tr('english'),
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
                            ),

                            // turkish
                            radioListTileLike<LocalizationLanguage>(
                              value: LocalizationLanguage.turkish,
                              groupValue: currentLocalizationMode,
                              label: tr('turkish'),
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
                                            .copyWith(color: Colors.blue)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                );

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
                    context.setLocale(const Locale('sw', 'SW'));
                  case LocalizationLanguage.iron:
                    context.setLocale(const Locale('km', 'KM'));
                  default:
                }
              },
            ),
          ),

          // Theme selection (replaced radios with provided structure)
          Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Colors.grey.withOpacity(0.2))))),
          ListTile(
            title: Text(tr('theme'),
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
                              left: 24, top: 16, bottom: 8),
                          child: Text(tr('theme'),
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontSize: 20)),
                        ),

                        // Light
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (theme.brightness == Brightness.dark)
                                AdaptiveTheme.of(context).setLight();
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Radio<Brightness>(
                                    fillColor: MaterialStateProperty
                                        .resolveWith<Color>((states) {
                                      if (states
                                          .contains(MaterialState.selected))
                                        return Colors.blue;
                                      return Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.blue
                                          : Colors.black;
                                    }),
                                    groupValue: theme.brightness,
                                    value: Brightness.light,
                                    onChanged: (_) {
                                      if (theme.brightness == Brightness.dark)
                                        AdaptiveTheme.of(context).setLight();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Flexible(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        left: 8, right: 24),
                                    title: Text(tr('light_theme'),
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(fontSize: 18)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Dark
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (theme.brightness == Brightness.light)
                                AdaptiveTheme.of(context).setDark();
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Radio<Brightness>(
                                    fillColor: MaterialStateProperty
                                        .resolveWith<Color>((states) {
                                      if (states
                                          .contains(MaterialState.selected))
                                        return Colors.blue;
                                      return Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.blue
                                          : Colors.black;
                                    }),
                                    groupValue: theme.brightness,
                                    value: Brightness.dark,
                                    onChanged: (_) {
                                      if (theme.brightness == Brightness.light)
                                        AdaptiveTheme.of(context).setDark();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Flexible(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        left: 8, right: 24),
                                    title: Text(tr('dark_theme'),
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(fontSize: 18)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                                child: Text(tr('cancel').toUpperCase(),
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.blue)),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                );
              },
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Colors.grey.withOpacity(0.2))))),
          // Split mode toggle (unchanged)
          InkWell(
            onTap: () {
              ref.read(splitModeProvider.notifier).newState =
                  !ref.read(splitModeProvider.notifier).state;
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 12.0, bottom: 12, left: 16.0, right: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr('split_screen'),
                            style: theme.textTheme.bodyMedium!
                                .copyWith(fontSize: 17)),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                          child: Text(tr('split_screen_subtitle'),
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontSize: 15)),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Checkbox(
                      value: ref.watch(splitModeProvider),
                      onChanged: (value) => ref
                          .read(splitModeProvider.notifier)
                          .newState = value!,
                      overlayColor: WidgetStateProperty.all(Colors.white),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Glossary / font size
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
                    final currentZoom = ref.watch(glossaryZoomProvider);

                    Widget radioLikeDouble(
                        {required double value, required String label}) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ref.read(glossaryZoomProvider.notifier).newState =
                                value == 0.9
                                    ? GlossaryZoomState.little
                                    : value == 1
                                        ? GlossaryZoomState.normal
                                        : GlossaryZoomState.big;
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Radio<double>(
                                  groupValue: currentZoom,
                                  value: value,
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states.contains(MaterialState.selected))
                                      return Colors.blue;
                                    return Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.blue
                                        : Colors.black;
                                  }),
                                  onChanged: (_) {
                                    ref.read(glossaryZoomProvider.notifier).newState =
                                        value == 0.9
                                            ? GlossaryZoomState.little
                                            : value == 1
                                                ? GlossaryZoomState.normal
                                                : GlossaryZoomState.big;
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Flexible(
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 8, right: 24),
                                  title: Text(label,
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(fontSize: 18)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, top: 16, bottom: 8),
                          child: Text(tr('font_size'),
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontSize: 20)),
                        ),
                        radioLikeDouble(value: 0.9, label: tr('little')),
                        radioLikeDouble(value: 1, label: tr('normal')),
                        radioLikeDouble(value: 1.1, label: tr('big')),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                                child: Text(tr('cancel').toUpperCase(),
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.blue)),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
