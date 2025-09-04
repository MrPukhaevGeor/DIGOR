import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

/// Преобразует текст со StyledText-тегами в HTML для WebView.
/// Использует карту tags, аналогичную StyledTextWidget.tags.
String styledTextToHtml({
  required String rawText,
  required Map<String, StyledTextTagBase> tags,
  required ThemeData theme,
  double zoom = 1.0,
}) {
  String html = rawText;

  tags.forEach((tag, styledTag) {
    if (styledTag is StyledTextTag) {
      final css = _textStyleToCss(styledTag.style, zoom);
      html = html.replaceAllMapped(
        RegExp('<$tag>(.*?)</$tag>', dotAll: true),
            (m) => '<span style="$css">${m[1]}</span>',
      );
    } else if (styledTag is StyledTextActionTag) {
      final css = _textStyleToCss(styledTag.style, zoom);
      html = html.replaceAllMapped(
        RegExp('<$tag>(.*?)</$tag>', dotAll: true),
            (m) => '<a href="$tag://${m[1]}" style="$css">${m[1]}</a>',
      );
    }
  });

  html = html.replaceAll("\n", "<br>");

  return """
  <html>
    <head>
      <meta charset="utf-8">
      <style>
        body {
          font-size: ${17 * zoom}px;
          line-height: 1.4;
          color: ${theme.textTheme.bodyMedium?.color?.value.toRadixString(16) ?? '#000'};
          user-select: text;      /* 👈 разрешаем выделение */
          -webkit-user-select: text;
        }
        a { text-decoration: none; }
      </style>
      <script>
        var underlinedTexts = document.querySelectorAll('.underlined-text');
        for(var t of underlinedTexts) {
          t.addEventListener('onClick', (e) => {
            underlinedTextSelectChannel.postMessage(JSON.stringify({
            text: e.target.innerText
           }))
          })
        }
      </script>
    </head>
    <body>
      $html
    </body>
  </html>
  """;
}


/// Преобразует TextStyle во встроенный CSS
String _textStyleToCss(TextStyle? style, double zoom) {
  if (style == null) return '';
  final css = <String>[];

  if (style.fontSize != null) css.add('font-size:${style.fontSize! * zoom}px');
  if (style.fontWeight != null) {
    if (style.fontWeight == FontWeight.bold) css.add('font-weight:bold');
  }
  if (style.fontStyle == FontStyle.italic) css.add('font-style:italic');
  if (style.decoration == TextDecoration.underline) {
    css.add('text-decoration:underline');
  } else if (style.decoration == TextDecoration.lineThrough) {
    css.add('text-decoration:line-through');
  }
  if (style.color != null) {
    final hex = style.color!.value.toRadixString(16).padLeft(8, '0');
    css.add('color:#${hex.substring(2)}');
  }
  if (style.fontFamily != null) css.add('font-family:${style.fontFamily}');

  return css.join('; ');
}
