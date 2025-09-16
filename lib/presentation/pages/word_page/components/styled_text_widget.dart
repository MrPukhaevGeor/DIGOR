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
    if (s.contains('<m3>')) return 9;
    if (s.contains('<m2>')) return 9;
    if (s.trimLeft().startsWith('<b>')) return 0;
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

    final baseTextStyle = TextStyle(
      fontFamily: 'Araboto',
      fontSize: 16 * zoom,
      fontWeight: FontWeight.w500,
      height: 1.2,
      color: theme.textTheme.bodyMedium!.color,
    );

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
          color: theme.brightness == Brightness.dark
              ? const Color.fromARGB(255, 0, 129, 255)
              : const Color.fromARGB(255, 0, 0, 238),
          fontSize: 14 * zoom, // ref всегда особый
        ),
      ),
      'b': StyledTextTag(
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      'trn': StyledTextTag(
        style: TextStyle(
          color: theme.textTheme.bodyMedium!.color,
        ),
      ),
      'u': StyledTextTag(
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
      'c': StyledTextTag(
        style: const TextStyle(
          color: Color.fromRGBO(1, 127, 1, 1),
        ),
      ),
      'i': StyledTextTag(
        style: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
      'ex': StyledTextTag(
        style: TextStyle(
          fontSize: 14 * zoom, // 👈 спецразмер только тут

          color: theme.brightness == Brightness.dark
              ? const Color.fromARGB(255, 206, 207, 255)
              : const Color.fromARGB(255, 0, 0, 97),
        ),
      ),
      "'": StyledTextTag(
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.lineThrough,
        ),
      ),
    };

    final spaceWidth = measureSpaceWidth(baseTextStyle);

    print(textLines);
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        children: [
          if (word.audioUrl == null)
            Positioned(
              top: 43 * zoom,
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
          // Оборачиваем всё в SelectionArea, чтобы можно было выделять весь текст целиком
          textLines.isEmpty
              ? const SizedBox.shrink()
              : SelectionArea(
                contextMenuBuilder: wordPageContextMenuBuilder,
                  magnifierConfiguration: const TextMagnifierConfiguration(
                      shouldDisplayHandlesInMagnifier: false),
                  child: Column(
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
                                  fontFamily: 'Araboto',
                                  fontWeight: FontWeight.w400),
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
                                fontSize: 30 * zoom,
                                fontFamily: 'Araboto',
                              ),
                            ),
                          },
                        ),
                        const SizedBox(height: 28),
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
                            padding:
                                EdgeInsets.only(left: leftIndent, right: 32),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Номер отдельным Text — SelectionArea позволит выделять между ним и остальным текстом
                                Text(numberPart, style: baseTextStyle),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: StyledText(
                                    key: ValueKey(e),
                                    newLineAsBreaks: true,
                                    text: restText,
                                    style: baseTextStyle,
                                    maxLines: maxLines,
                                    tags: tags,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // обычная строка
                          return Padding(
                            padding:
                                EdgeInsets.only(left: leftIndent, right: 32),
                            child: StyledText(
                              key: ValueKey(e),
                              newLineAsBreaks: true,
                              text: cleaned,
                              style: baseTextStyle,
                              maxLines: maxLines,
                              tags: tags,
                            ),
                          );
                        }
                      }).toList(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
