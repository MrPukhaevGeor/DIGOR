import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/models/word_model.dart';
import '../../../providers/history.dart';
import '../../../providers/search_mode.dart';
import '../../../providers/textfield_provider.dart';
import '../../word_page/word_page_model.dart';
import '../home_page_model.dart';
import 'clear_history_widget.dart';
import 'custom_popup_menu_button.dart';

class AppBarWidget extends ConsumerWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppBarWidget({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    String dropDownValueFirst = '';
    String dropDownValueSecond = '';
    List<String> dropDownFirstValues = [];
    List<String> dropDownSecondValues = [];
    final searchMode = ref.watch(searchModeProvider).value;
    switch (searchMode) {
      case LanguageMode.digEnglish:
        dropDownValueFirst = tr('digor');
        dropDownValueSecond = tr('english');
        dropDownFirstValues = [
          tr('digor'),
          tr('iron'),
        ];
        dropDownSecondValues = [
          tr('english'),
          tr('russian'),
          // tr('turkish'),
        ];

      case LanguageMode.digRussian:
        dropDownValueFirst = tr('digor');
        dropDownValueSecond = tr('russian');
        dropDownFirstValues = [
          tr('digor'),
          tr('iron'),
        ];
        dropDownSecondValues = [
          tr('russian'),
          tr('english'),
          // tr('turkish'),
        ];

      case LanguageMode.digTurkish:
        dropDownValueFirst = tr('digor');
        dropDownValueSecond = tr('turkish');
        dropDownFirstValues = [
          tr('digor'),
          tr('iron'),
        ];
        dropDownSecondValues = [
          // tr('turkish'),
          tr('russian'),
          tr('english'),
        ];

      case LanguageMode.engDigor:
        dropDownValueFirst = tr('english');
        dropDownValueSecond = tr('digor');
        dropDownFirstValues = [
          tr('english'),
          tr('russian'),
          // tr('turkish'),
        ];
        dropDownSecondValues = [
          tr('digor'),
          tr('iron'),
        ];

      case LanguageMode.rusDigor:
        dropDownValueFirst = tr('russian');
        dropDownValueSecond = tr('digor');
        dropDownFirstValues = [
          tr('russian'),
          tr('english'),
          // tr('turkish'),
        ];
        dropDownSecondValues = [
          tr('digor'),
          tr('iron'),
        ];

      case LanguageMode.turkDigor:
        dropDownValueFirst = tr('turkish');
        dropDownValueSecond = tr('digor');
        dropDownFirstValues = [
          // tr('turkish'),
          tr('russian'), tr('english')
        ];
        dropDownSecondValues = [
          tr('digor'),
          tr('iron'),
        ];

      case LanguageMode.ironRussian:
        dropDownValueFirst = tr('iron');
        dropDownValueSecond = tr('russian');
        dropDownFirstValues = [
          tr('iron'),
          tr('digor'),
        ];
        dropDownSecondValues = [
          tr('russian'),
          // tr('english'),
          // tr('turkish'),
        ];

      // case LanguageMode.ironEnglish:
      //   dropDownValueFirst = tr('iron');
      //   dropDownValueSecond = tr('english');
      //   dropDownFirstValues = [
      //     tr('iron'),
      //     tr('digor'),
      //   ];
      //   dropDownSecondValues = [
      //     tr('english'),
      //     tr('russian'),
      //     // tr('turkish'),
      //   ];

      // case LanguageMode.ironTurkish:
      //   dropDownValueFirst = tr('iron');
      //   // dropDownValueSecond = tr('turkish');
      //   dropDownFirstValues = [
      //     tr('iron'),
      //     tr('digor'),
      //   ];
      //   dropDownSecondValues = [
      //     // tr('turkish'),
      //     tr('russian'),
      //     tr('english'),
      //   ];

      case LanguageMode.rusIron:
        dropDownValueFirst = tr('russian');
        dropDownValueSecond = tr('iron');
        dropDownFirstValues = [
          tr('russian'),
          // tr('english'),
          // tr('turkish'),
        ];
        dropDownSecondValues = [
          tr('iron'),
          tr('digor'),
        ];

      // case LanguageMode.engIron:
      //   dropDownValueFirst = tr('english');
      //   dropDownValueSecond = tr('iron');
      //   dropDownFirstValues = [
      //     tr('english'),
      //     tr('russian'),
      //     // tr('turkish'),
      //   ];
      //   dropDownSecondValues = [
      //     tr('iron'),
      //     tr('digor'),
      //   ];

      // case LanguageMode.turkIron:
      //   dropDownValueFirst = tr('turkish');
      //   dropDownValueSecond = tr('iron');
      //   dropDownFirstValues = [
      //     // tr('turkish')
      //     tr('russian'), tr('english')
      //   ];
      //   dropDownSecondValues = [
      //     tr('iron'),
      //     tr('digor'),
      //   ];

      default:
        dropDownValueFirst = tr('digor');
        dropDownValueSecond = tr('russian');
        dropDownFirstValues = [
          tr('digor'),
          tr('iron'),
        ];
        dropDownSecondValues = [
          tr('russian'),
          tr('english'),
          // tr('turkish'),
        ];
    }
    final history = ref.watch(historyProvider).value;

    final isShowingExamples =
        ref.watch(exampleModeProvider) == ExampleModeEnum.show;
    final selectedId = ref.watch(selectedBottomPanelWordIdProvider);
    final WordModel? word = selectedId == -1
        ? null
        : ref.watch(fetchWordProvider(selectedId)).value;

    final dropDawnItems = [
      if (!ref.watch(translateModeProvider))
        DropdownMenuItem(
          enabled: history != null && history.isNotEmpty,
          value: tr('clear_history'),
          onTap: () {},
          child: Text(
            tr('clear_history'),
            style: TextStyle(
              fontFamily: 'BrisaSans',
              color: theme.textTheme.bodyMedium!.color!.withOpacity(
                history != null && history.isNotEmpty ? 1 : .2,
              ),
            ),
          ),
        ),
      // if (ref.watch(splitModeProvider))
      //   DropdownMenuItem(
      //     enabled: word?.body?.contains('[ex]') ?? false,
      //     value: isShowingExamples ? tr('hide_examples') : tr('show_examples'),
      //     onTap: ref.read(exampleModeProvider.notifier).toggleExampleMode,
      //     child: Text(
      //       isShowingExamples ? tr('hide_examples') : tr('show_examples'),
      //       style: TextStyle(
      //           color: theme.textTheme.bodyMedium!.color!.withOpacity(
      //         word == null
      //             ? 0.2
      //             : word.body == null
      //                 ? 0.2
      //                 : word.body!.contains('[ex]')
      //                     ? 1
      //                     : .2,
      //       )),
      //     ),
      //   ),
    ];
    return AppBar(
      titleSpacing: 0,
      title: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CustomPopupMenuButton<String>(
                onSelected: (value) {
                  if (value != null) {
                    ref
                        .read(searchModeProvider.notifier)
                        .onDropDownSecondChange(value);
                  }
                  ref
                      .read(textFieldValueProvider.notifier)
                      .focusNode
                      .requestFocus();
                },
                items: dropDownFirstValues
                    .map(
                      (value) => PopupMenuItem<String>(
                        padding: EdgeInsets.zero,

                        value: value,
                        height: kToolbarHeight -
                            8, // Высота элемента (можно настроить)
                        child: Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    )
                    .toList(),
                right: false,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          dropDownValueFirst,
                          // maxLines: 1,
                          style: theme.textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      if (dropDownFirstValues.isNotEmpty)
                        const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              splashRadius: 20,
              onPressed:
                  ref.read(searchModeProvider.notifier).onSwitchLanguageTap,
              icon: const Icon(
                Icons.compare_arrows_outlined,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: CustomPopupMenuButton<String>(
                onSelected: (value) {
                  print(value);
                  if (value != null) {
                    ref
                        .read(searchModeProvider.notifier)
                        .onDropDownSecondChange(value);
                  }

                  ref
                      .read(textFieldValueProvider.notifier)
                      .focusNode
                      .requestFocus();
                },
                items: dropDownSecondValues
                    .map(
                      (value) => PopupMenuItem<String>(
                        padding: EdgeInsets.zero,

                        value: value,
                        height: kToolbarHeight -
                            8, // Высота элемента (можно настроить)
                        child: SizedBox(
                          child: Text(
                            value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                right: true,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          dropDownValueSecond,
                          maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (dropDownSecondValues.isNotEmpty)
                        const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: const [ClearHistoryButton()],
    );
  }
}
