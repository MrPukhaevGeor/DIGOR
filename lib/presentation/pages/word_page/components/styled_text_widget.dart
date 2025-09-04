import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_text/styled_text.dart';

import '../../../../domain/models/word_model.dart';
import '../../../../navigator/navigate_effect.dart';
import '../../../../outside_functions.dart';
import '../../../providers/search_mode.dart';
import '../../home_page/home_page_model.dart';
import '../word_page.dart';
import '../word_page_model.dart';

class StyledTextWidget extends ConsumerWidget {
  final bool isShowingExamples;
  final WordModel word;
  final int? maxLines;

  const  StyledTextWidget({
    super.key,
    this.isShowingExamples = true,
    required this.word,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textLines = splitStringByTab(word.body ?? '');

    final theme = Theme.of(context);
    const mPadding = 10;
    final dicName = ref.read(searchModeProvider.notifier).getFullLanguageMode();
    final zoom = ref.watch(articleZoomProvider);

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        children: [
          if (word.audioUrl == null)
            Positioned(
              top: 30 * zoom,
              left: 0,
              right: 0,
              child: SizedBox(
                  height: 1,
                  child: Divider(
                      thickness: 1,
                      endIndent: 10,
                      color: theme.primaryColor.withOpacity(.5))),
            ),
          textLines.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (isShowingExamples
                          ? textLines
                          : textLines.where((element) =>
                              !element.contains('<m2>') &&
                              !element.contains('<m3>')))
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.only(
                            /*left: e.contains('m1')
                                ? mPadding * 1
                                : e.contains('m2')
                                    ? mPadding * 2
                                    : e.contains('m3')
                                        ? mPadding * 3
                                        : mPadding * 0,*/
                            right: 32,
                          ),
                          child: Consumer(builder: (context, ref, child) {
                            return StyledText.selectable(
                              newLineAsBreaks: true,
                              key: ValueKey(e),
                              selectionHeightStyle: BoxHeightStyle.includeLineSpacingMiddle,
                              text:
                                  '${word.audioUrl == null ? '<dict>Essential ($dicName)\n\n\n</dict>><title>${word.title}</title>\n\n' : null}${e}',
                              style: theme.textTheme.bodySmall!.copyWith(
                                fontSize: 17 * zoom,
                                height: 1,



                                color: theme.textTheme.bodyMedium!.color,
                                fontFamily: 'BrisaSans',
                                fontWeight: FontWeight.w300,
                              ),
                              magnifierConfiguration: TextMagnifierConfiguration(
                                shouldDisplayHandlesInMagnifier: false
                              ),
                              maxLines: maxLines,


                              tags: {
                                'ref': StyledTextActionTag(
                                  (String? text, Map<String?, String?> attrs) {
                                    if (word.refs!.containsKey(text)) {
                                      try {
                                        ref.read(splitModeProvider)
                                            ? ref
                                                .read(
                                                    selectedBottomPanelWordIdProvider
                                                        .notifier)
                                                .id = word.refs![text]!
                                            : Navigator.of(context).push(
                                                NavigateEffects
                                                    .fadeTransitionToPage(
                                                        WordPage(
                                                            word.refs![text]!)));
                                      } catch (e) {
                                        print(e);
                                      }
                                    } else {
                                      OutsideFunctions.showRefSnackBar(
                                          context, text ?? '');
                                    }
                                  },
                                  style: TextStyle(
                                      fontFamily: 'BrisaSans',
                                      color: theme.brightness == Brightness.dark
                                          ? const Color.fromARGB(255, 0, 129, 255)
                                          : const Color.fromARGB(255, 0, 0, 238)),
                                ),
                                'b': StyledTextTag(
                                    style: const TextStyle(
                                      fontFamily: 'BrisaSans',
                                      height: 1,
                                  fontWeight: FontWeight.bold,
                                )),
                                'u': StyledTextTag(
                                    style: const TextStyle(
                                        fontFamily: 'BrisaSans',
                                      height: 1,
                                        decoration: TextDecoration.underline)),
                                'c': StyledTextTag(
                                    style: const TextStyle(
                                        fontFamily: 'BrisaSans',
                                      height: 1,
                                        color: Color.fromRGBO(0, 127, 0, 1))),
                                'i': StyledTextTag(
                                    style: const TextStyle(
                                        fontFamily: 'BrisaSans',
                                        fontStyle: FontStyle.italic,height: 1)),
                                'ex': StyledTextTag(
                                    style: TextStyle(
                                        fontFamily: 'BrisaSans',
                                        color: theme.brightness == Brightness.dark
                                            ? const Color.fromARGB(
                                                255, 206, 207, 255)
                                            : const Color.fromARGB(
                                                255, 0, 0, 97),height: 1)),
                                'm2': StyledTextTag(

                                    style: TextStyle(
                                        fontFamily: 'BrisaSans',fontSize: 15 * zoom,height: 1)),
                                'm3': StyledTextTag(
                                    style: TextStyle(
                                        fontFamily: 'BrisaSans',fontSize: 15 * zoom,height: 1
                                    )),
                                'title': StyledTextTag(
                                  style: theme.textTheme.headlineSmall!.copyWith(
                                    fontSize: 28 * zoom,
                                    fontFamily: 'BrisaSans',

                                  ),
                                ),
                                'dict': StyledTextTag(
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                  fontSize: 17 * zoom,
                                  fontFamily: 'BrisaSans',
                                )),
                                "'": StyledTextTag(
                                    style: const TextStyle(
                                        fontFamily: 'BrisaSans',
                                      height: 1,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.lineThrough)),
                              },
                            );
                          }),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }

  List<String> splitStringByTab(String textToSplit) {
    final list = textToSplit
        .split(utf8.decode([10]))
        .where((element) => element.trim().isNotEmpty)
        .map((e) => formatText(e).trim())
        .toList();

    print(list);
    return [
      List.generate(list.length, (index) {
        final e = list[index];
        return '${index > 0 ? '\n' : ''}${e.contains('m1') ? '' : e.contains('m2') ? '   ' : e.contains('m3') ? '      ' : ''}$e';
      }).join('')
    ];
  }

  String formatText(String textToFormat) {
    return textToFormat.replaceAll('[', '<').replaceAll(']', '>');
  }
}
