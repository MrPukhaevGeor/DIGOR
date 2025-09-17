// --- вставь этот вспомогательный виджет рядом с _dictionaryWidget в том же файле ---

import 'package:flutter/material.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/tags/styled_text_tag_base.dart';
import 'package:styled_text/widgets/styled_text.dart';

class AlignedDescription extends StatelessWidget {
  final String description;
  final TextStyle style;
  final Map<String, StyledTextTagBase> tags;
  const AlignedDescription({
    required this.description,
    required this.style,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    // Разбиваем по строкам и парсим левую/правую части
    final lines = description.split('\n');
    final parsed = <MapEntry<String, String>>[];

    final splitRe = RegExp(r'\s{2,}'); // два и более пробела — граница столбцов

    for (final raw in lines) {
      final line = raw.trimRight();
      final m = splitRe.firstMatch(line);
      if (m != null) {
        final left = line.substring(0, m.start).trimRight();
        final right = line.substring(m.end).trim();
        parsed.add(MapEntry(left, right));
      } else {
        // если не нашли разделитель — левая колонка = вся строка, правая пустая
        parsed.add(MapEntry(line.trim(), ''));
      }
    }

    // Если все правые строки пусты — вернём обычный StyledText как fallback
    final anyRight = parsed.any((e) => e.value.isNotEmpty);
    if (!anyRight) {
      return StyledText(
        text: description,
        style: style,
        tags: tags,
      );
    }

    // Формируем Table: левая колонка растёт, правая — IntrinsicColumnWidth (одинаковая ширина)
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: parsed.map((entry) {
        final left = entry.key;
        final right = entry.value;
        return TableRow(decoration: BoxDecoration(),
          children: [
            // Левая ячейка: используем StyledText, но если пустая — пустая Container
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: left.isEmpty
                  ? const SizedBox.shrink()
                  : StyledText(
                      text: left,
                      style: style,
                      tags: tags,
                    ),
            ),
            // Правая ячейка: выровнять по правому краю
            Padding(
              padding: const EdgeInsets.only(bottom: 2, left: 8),
              child: right.isEmpty
                  ? const SizedBox.shrink()
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: StyledText(
                        text: right,
                        style: style,
                        tags: tags,
                      ),
                    ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
