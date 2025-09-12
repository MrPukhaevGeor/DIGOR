import 'package:easy_localization/easy_localization.dart' as l;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app.dart';
import 'domain/models/word_model.dart';
import 'presentation/providers/api_provider.dart';
import 'presentation/providers/localization.dart';
import 'presentation/providers/search.dart';
import 'presentation/providers/search_mode.dart';
import 'package:flutter/material.dart';

/// Виджет: обрезает строку по ширине и добавляет ".." вместо стандартного "…"
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';

// Использует глобальную локализацию 'l.tr' и assets как в твоём проекте.
// Класс управляет единственным OverlayEntry и обновляет только число.
import 'dart:async';
import 'package:flutter/material.dart';

class ZoomOverlay {
  static OverlayEntry? _entry;
  static ValueNotifier<int>? _notifier;
  static Timer? _hideTimer;
  static late AnimationController _controller;
  static late Animation<double> _animation;

  /// Показывает (или обновляет) overlay с процентом зума.
  static void show(BuildContext context, double zoom,
      {Duration duration = const Duration(seconds: 1)}) {
    final int percent = (zoom * 100).round();

    if (_notifier == null) {
      _notifier = ValueNotifier<int>(percent);
    } else {
      _notifier!.value = percent;
    }

    // Если Overlay ещё не вставлен — вставляем его
    if (_entry == null) {
      final overlay = Overlay.of(context);
      if (overlay == null) return;

      _controller = AnimationController(
        vsync: overlay, // OverlayState имеет TickerProvider
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 200),
      );

      _animation =
          CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

      _entry = OverlayEntry(builder: (ctx) {
        final theme = Theme.of(ctx);
        return Positioned(
          bottom: 70 + MediaQuery.of(ctx).viewInsets.bottom,
          left: 0,
          right: 0,
          child: IgnorePointer(
            ignoring: true,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: FadeTransition(
                  opacity: _animation,
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.5),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Image.asset('assets/white.png'),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${l.tr('zoom')} ',
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: Colors.white, fontSize: 15),
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: _notifier!,
                          builder: (context, value, child) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(opacity: anim, child: child),
                              child: Text(
                                '$value%',
                                key: ValueKey<int>(value),
                                style: theme.textTheme.bodySmall!.copyWith(
                                    color: Colors.white, fontSize: 15),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });

      overlay.insert(_entry!);
      _controller.forward(); // анимация появления
    }

    // Обновляем таймер скрытия
    _hideTimer?.cancel();
    _hideTimer = Timer(duration, () {
      hide();
    });
  }

  /// Скрыть overlay с анимацией
  static Future<void> hide() async {
    _hideTimer?.cancel();
    _hideTimer = null;

    if (_entry != null) {
      await _controller.reverse(); // плавное исчезновение
      _entry?.remove();
      _entry = null;
      _controller.dispose();
    }

    _notifier?.dispose();
    _notifier = null;
  }
}


/// Виджет: обрезает строку по ширине и добавляет ".." вместо стандартного "…"
class TwoDotEllipsis extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final double? maxWidthOverride; // если заранее знаешь ширину
  final TextScaler? textScaler; // <- новый параметр

  const TwoDotEllipsis({
    Key? key,
    required this.text,
    this.style,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.locale,
    this.maxWidthOverride,
    this.textScaler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Определяем effective TextScaler: либо переданный, либо системный.
    final effectiveTextScaler = textScaler ?? MediaQuery.of(context).textScaler;

    // textScaleFactor, который передаём в TextPainter
    final double textScaleFactor = effectiveTextScaler.scale(1.0);

    return LayoutBuilder(builder: (context, constraints) {
      final double maxWidth = maxWidthOverride ?? constraints.maxWidth;

      // Если ширина бесконечна, просто рисуем текст — нет ограничений.
      if (maxWidth.isInfinite) {
        return Text(
          text,
          style: style,
          maxLines: maxLines,
          overflow: TextOverflow.clip,
          textAlign: textAlign,
          textScaler: effectiveTextScaler,
        );
      }

      final effectiveDirection = textDirection ?? Directionality.of(context);

      // Быстрая проверка: помещается ли весь текст
      final TextPainter fullTp = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: effectiveDirection,
        maxLines: maxLines,
        textScaleFactor: textScaleFactor,
        locale: locale,
      )..layout(maxWidth: maxWidth);

      if (!fullTp.didExceedMaxLines) {
        return Text(
          text,
          style: style,
          maxLines: maxLines,
          overflow: TextOverflow.clip,
          textAlign: textAlign,
          textScaler: effectiveTextScaler,
        );
      }

      // Проверяем, помещается ли вообще ".."
      final TextPainter dotsTp = TextPainter(
        text: TextSpan(text: '..', style: style),
        textDirection: effectiveDirection,
        maxLines: maxLines,
        textScaleFactor: textScaleFactor,
        locale: locale,
      )..layout(maxWidth: maxWidth);

      if (dotsTp.didExceedMaxLines) {
        // Даже две точки не помещаются — вернём только '..'
        return Text(
          '..',
          style: style,
          maxLines: maxLines,
          overflow: TextOverflow.clip,
          textAlign: textAlign,
          textScaler: effectiveTextScaler,
        );
      }

      // Бинарный поиск максимальной подстроки, которая поместится с двумя точками
      int low = 0;
      int high = text.length;
      while (low < high) {
        final mid = (low + high + 1) >> 1;
        final candidate = text.substring(0, mid) + '..';
        final tp = TextPainter(
          text: TextSpan(text: candidate, style: style),
          textDirection: effectiveDirection,
          maxLines: maxLines,
          textScaleFactor: textScaleFactor,
          locale: locale,
        )..layout(maxWidth: maxWidth);

        if (tp.didExceedMaxLines) {
          high = mid - 1;
        } else {
          low = mid;
        }
      }

      final result = low > 0 ? text.substring(0, low) + '..' : '..';

      return Text(
        result,
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.clip,
        textAlign: textAlign,
        textScaler: effectiveTextScaler,
      );
    });
  }
}

class OutsideFunctions {
  static Future<void> sendMail(BuildContext context) async {
    final uri = Uri.parse('mailto:digor.dict@gmail.com?subject=DigorApp');
    try {
      await launchUrl(uri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor:
              const Color.fromARGB(255, 45, 32, 65).withOpacity(.9),
          content: Text('${l.tr('could_not_open_the_mail')}...'),
        ),
      );
    }
  }

  static Future<void> showCopiedSnackBar(
      BuildContext context, WordModel word) async {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    await Clipboard.setData(ClipboardData(
            text:
                '${word.title.trim()}\n${word.translate}\n${word.body?.trim() ?? ''}'))
        .whenComplete(
      () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.black.withOpacity(.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text(
            '"${word.title}" - ${l.tr('copied')}',
            style: theme.textTheme.bodySmall!
                .copyWith(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  static Future<void> showZoomSnackBar(
      BuildContext context, double zoom) async {
    ZoomOverlay.show(context, zoom, duration: const Duration(seconds: 1));
  }

  static Future<void> showRefSnackBar(BuildContext context, String word) async {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black.withOpacity(.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        behavior: SnackBarBehavior.floating,
        content: Text('${l.tr('word')} $word ${l.tr('not_found')}',
            style: theme.textTheme.bodySmall!.copyWith(color: Colors.white)),
      ),
    );
  }

  static Future<void> share(bool isIOS) async {
    await Share.share(
      !isIOS
          ? 'https://play.google.com/store/apps/details?id=com.budajti.digor'
          : 'https://apps.apple.com/us/app/digor-%D0%BE%D0%BD%D0%BB%D0%B0%D0%B9%D0%BD-%D1%81%D0%BB%D0%BE%D0%B2%D0%B0%D1%80%D1%8C/id6449050450',
    );
  }

  static void showWriteToDeveloperDialog(
      BuildContext context, String title, WidgetRef ref) {
    final theme = Theme.of(context);
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 26),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SamsungOne'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: theme.canvasColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 200,
                  child: TextField(
                    style: theme.textTheme.bodyMedium!.copyWith(
                        fontSize: 14, decoration: TextDecoration.none),
                    controller: controller,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: l.tr('message_text'),
                        hintStyle: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 14,
                            color: theme.textTheme.bodySmall!.color!
                                .withOpacity(0.3),
                            fontFamily: 'SamsungOne')),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: Navigator.of(context).pop,
                        child: Text(l
                            .tr(
                              'cancel',
                            )
                            .toUpperCase()),
                      ),
                      TextButton(
                        child: Text(l.tr('send').toUpperCase()),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (controller.text.trim().isNotEmpty) {
                            // ref.read(apiClientProvider).addReport(
                            //   {
                            //     'text': controller.text.trim(),
                            //     'date': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())
                            //   },
                            // );
                            // FirebaseFirestore.instance.collection('reports').add(
                            //   {
                            //     'report': controller.text.trim(),
                            //     'report_date': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())
                            //   },
                            // );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showChangeLanguageDialog(BuildContext context) {
    final theme = Theme.of(context);
  }

  static Future<void> showClearHistoryDialog(
      BuildContext context, Function callback, String content) async {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(2),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 22),
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: double.infinity),
                Text(content,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
                const SizedBox(height: 20),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: Navigator.of(context).pop,
                        child: Text(
                          l.tr('no').toUpperCase(),
                        ),
                      ),
                      TextButton(
                        child: Text(
                          l.tr('yes').toUpperCase(),
                        ),
                        onPressed: () {
                          callback();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
