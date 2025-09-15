import 'dart:convert';
import 'dart:ui';
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

  const StyledTextWidget({
    super.key,
    this.isShowingExamples = true,
    required this.word,
    this.maxLines,
  });

  /// --- ХЕЛПЕРЫ ---

  double measureSpaceWidth(TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: ' ', style: style),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    return tp.width;
  }

  int detectIndentSpaces(String line) {
    final s = line.toLowerCase();
    if (s.contains('<m3>')) return 8;
    if (s.contains('<m2>')) return 8;
    if (s.trimLeft().startsWith('<b>')) return 2;
    if (s.contains('<m1>')) return 4;
    return 0;
  }

  List<String> splitStringByTab(String textToSplit) {
    final list = textToSplit
        .split(utf8.decode([10]))
        .where((element) => element.trim().isNotEmpty)
        .map((e) => formatText(e).trim())
        .toList();
    return list;
  }

  String formatText(String textToFormat) {
    return textToFormat.replaceAll('[', '<').replaceAll(']', '>');
  }

  bool isNumberedLine(String text) {
    // простая проверка на начало строки "цифра+)"
    final trimmed = text.trimLeft();
    final regex = RegExp(r'^\d+\)');
    return regex.hasMatch(trimmed);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textLines = splitStringByTab(word.body ?? '');
    final theme = Theme.of(context);
    final dicName = ref.read(searchModeProvider.notifier).getFullLanguageMode();
    final zoom = ref.watch(articleZoomProvider);

    final baseTextStyle = theme.textTheme.bodySmall!.copyWith(
      fontSize: 17 * zoom,
      height: 1,
      fontFamily: 'BrisaSans',
      fontWeight: FontWeight.w300,
    );
    final spaceWidth = measureSpaceWidth(baseTextStyle);

    final Map<String, StyledTextTagBase> tags = {
      'ref': StyledTextActionTag(
        (String? text, Map<String?, String?> attrs) {
          if (word.refs!.containsKey(text)) {
            try {
              ref.read(splitModeProvider)
                  ? ref.read(selectedBottomPanelWordIdProvider.notifier).id =
                      word.refs![text]!
                  : Navigator.of(context).push(
                      NavigateEffects.fadeTransitionToPage(
                          WordPage(word.refs![text]!)));
            } catch (err) {
              print(err);
            }
          } else {
            OutsideFunctions.showRefSnackBar(context, text ?? '');
          }
        },
        style: TextStyle(
          fontFamily: 'BrisaSans',
          fontSize: 13 * zoom,
          color: theme.brightness == Brightness.dark
              ? const Color.fromARGB(255, 0, 129, 255)
              : const Color.fromARGB(255, 0, 0, 238),
        ),
      ),
      'b': StyledTextTag(
        style:  TextStyle(
          fontFamily: 'BrisaSans',
          height: 1,
          fontSize: 15 * zoom,
          fontWeight: FontWeight.bold,
        ),
      ),
      'trn': StyledTextTag(
        style: TextStyle(
          fontFamily: 'BrisaSans',
          fontSize: 15 * zoom,
          fontWeight: FontWeight.w500,
          color: theme.textTheme.bodyMedium!.color,
          height: 1,
        ),
      ),
      'u': StyledTextTag(
        style: TextStyle(
          fontFamily: 'BrisaSans',
          height: 1,
          fontSize: 14 * zoom,
          decoration: TextDecoration.underline,
        ),
      ),
      'c': StyledTextTag(
        style: TextStyle(
          fontFamily: 'BrisaSans',
          height: 1,
          fontSize: 15 * zoom,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(1, 127, 1, 1),
        ),
      ),
      'i': StyledTextTag(
        style: TextStyle(
          fontFamily: 'BrisaSans',
          fontSize: 15 * zoom,
          fontStyle: FontStyle.italic,
          height: 1,
        ),
      ),
      'ex': StyledTextTag(
        style: TextStyle(
          fontSize: 13 * zoom,
          fontWeight: FontWeight.w500,
          fontFamily: 'BrisaSans',
          color: theme.brightness == Brightness.dark
              ? const Color.fromARGB(255, 206, 207, 255)
              : const Color.fromARGB(255, 0, 0, 97),
          height: 1,
        ),
      ),
      "'": StyledTextTag(
        style: const TextStyle(
          fontFamily: 'BrisaSans',
          height: 1,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.lineThrough,
        ),
      ),
    };
    print(textLines);
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        children: [
          if (word.audioUrl == null)
            Positioned(
              top: 51 * zoom,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 1,
                child: Divider(
                  thickness: 1,
                  endIndent: 10,
                  color: theme.primaryColor.withOpacity(.5),
                ),
              ),
            ),
          textLines.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),

                    if (word.audioUrl == null) ...[
                      StyledText(
                        text: '<dict>Language ($dicName)</dict>',
                        style: baseTextStyle,
                        tags: {
                          'dict': StyledTextTag(
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontSize: 17 * zoom,
                              fontFamily: 'BrisaSans',
                            ),
                          ),
                        },
                      ),
                      const SizedBox(height: 40),
                      StyledText(
                        text: '<title>${word.title}</title>',
                        style: baseTextStyle,
                        tags: {
                          'title': StyledTextTag(
                            style: theme.textTheme.headlineSmall!.copyWith(
                              fontSize: 28 * zoom,
                              fontFamily: 'BrisaSans',
                            ),
                          ),
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Контент по строкам
                    ...textLines.map((e) {
                      final spaces = detectIndentSpaces(e);
                      final leftIndent = spaces * spaceWidth;

                      final cleaned = e
                          .replaceAll(RegExp(r'<m[1-3]>'), '')
                          .replaceAll(RegExp(r'</m>'), '')
                          .replaceAll('<*>', '')
                          .replaceAll('</*>', '')
                          .trimLeft();

                      if (isNumberedLine(cleaned)) {
                        // висячий отступ через Row + Expanded
                        final match = RegExp(r'^(\d+\))').firstMatch(cleaned);
                        final numberPart = match?.group(1) ?? '';
                        final restText =
                            cleaned.substring(numberPart.length).trimLeft();

                        return Padding(
                          padding: EdgeInsets.only(left: leftIndent, right: 32),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(numberPart, style: baseTextStyle),
                              const SizedBox(width: 6),
                              Expanded(
                                child: StyledText.selectable(
                                  key: ValueKey(e),
                                  newLineAsBreaks: true,
                                  selectionHeightStyle:
                                      BoxHeightStyle.includeLineSpacingMiddle,
                                  text: restText,
                                  style: baseTextStyle,
                                  maxLines: maxLines,
                                  magnifierConfiguration:
                                      const TextMagnifierConfiguration(
                                          shouldDisplayHandlesInMagnifier:
                                              false),
                                  tags: tags,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // обычная строка
                        return Padding(
                          padding: EdgeInsets.only(left: leftIndent, right: 32),
                          child: StyledText.selectable(
                            key: ValueKey(e),
                            newLineAsBreaks: true,
                            selectionHeightStyle:
                                BoxHeightStyle.includeLineSpacingMiddle,
                            text: cleaned,
                            style: baseTextStyle,
                            maxLines: maxLines,
                            magnifierConfiguration:
                                const TextMagnifierConfiguration(
                                    shouldDisplayHandlesInMagnifier: false),
                            tags: tags,
                          ),
                        );
                      }
                    }).toList(),
                  ],
                ),
        ],
      ),
    );
  }
}
