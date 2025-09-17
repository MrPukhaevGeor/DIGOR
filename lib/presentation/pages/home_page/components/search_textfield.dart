import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../navigator/navigate_effect.dart';
import '../../../../outside_functions.dart';
import '../../../providers/search.dart';
import '../../../providers/textfield_provider.dart';
import '../../word_page/word_page.dart';
import '../home_page_model.dart';

class SearchTextfield extends ConsumerWidget {
  const SearchTextfield({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popupOpen = ref.watch(popupMenuOpenProvider);
    final blockFormatter = BlockFirstCharIfPopupOpenFormatter(
      // читает текущее состояние попапа
      isPopupOpen: () => ref.read(popupMenuOpenProvider),
      // тут — действие, закрывающее попап. Подставь свою реализацию:
      onFirstKeyWhenPopupOpen: () {
        ref.read(popupMenuOpenProvider.notifier).state = false;

        ref.read(popupMenuClearTextOpenProvider).call();
      },
    );
    final isCursorShow = !ref.watch(popupMenuOpenProvider);
    print(isCursorShow);
    final theme = Theme.of(context);
    final wordList =
        ref.watch(searchProvider(ref.watch(textFieldValueProvider)));
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding:
            const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
        child: Column(
          children: [
            TextField(
              inputFormatters: [
                blockFormatter,
              ],
              magnifierConfiguration: const TextMagnifierConfiguration(
                  shouldDisplayHandlesInMagnifier: false),
              contextMenuBuilder: ref.read(popupMenuOpenProvider)
                  ? null
                  : (BuildContext ctx, EditableTextState editableTextState) {
                      // координаты тулбара
                      final anchors = editableTextState.contextMenuAnchors;
                      // все возможные кнопки (cut/copy/paste/selectAll/share и т.д.)
                      final List<ContextMenuButtonItem> allItems =
                          editableTextState.contextMenuButtonItems;

                      // Оставляем только copy, selectAll и share
                      final wanted = <ContextMenuButtonType>{
                        ContextMenuButtonType.selectAll,
                        ContextMenuButtonType.paste,
                        ContextMenuButtonType.copy,
                      };

                      final filtered = allItems
                          .where((item) => wanted.contains(item.type))
                          .toList();
                      if (filtered.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      final buttons = filtered.map((item) {
                        String title;
                        switch (item.type) {
                          case ContextMenuButtonType.copy:
                            title = tr('copy'); // твоя локаль
                            break;
                          case ContextMenuButtonType.paste:
                            title = tr('paste'); // твоя локаль
                            break;
                          case ContextMenuButtonType.selectAll:
                            title = tr('select_all');
                            break;

                          default:
                            title = item.label ?? '';
                        }

                        return TextButton(
                          onPressed: item.onPressed,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                          ),
                          child: Text(
                            title,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList();
                      // Возвращаем стандартный TextSelectionToolbar, но с нашим Material (для скругления)
                      return TextSelectionToolbar(
                        anchorAbove: anchors.primaryAnchor,
                        anchorBelow:
                            anchors.secondaryAnchor ?? anchors.primaryAnchor,
                        toolbarBuilder: (BuildContext ctx, Widget child) {
                          return Material(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // <-- здесь меняй скругление
                            ),
                            child: child,
                          );
                        },
                        children: buttons,
                      );
                    },
              cursorHeight: MediaQuery.of(context).textScaler.scale(24),
              onSubmitted: (_) {
                if (ref.read(translateModeProvider) &&
                    wordList.value != null &&
                    wordList.value!.isNotEmpty) {
                  Navigator.of(context).push(
                      NavigateEffects.fadeTransitionToPage(WordPage(
                          wordList.value!.first.translationId ??
                              wordList.value!.first.id)));
                }
              },
              showCursor: isCursorShow,
              focusNode: ref.read(textFieldValueProvider.notifier).focusNode,
              controller: textController,
              autofocus: true,
              style: theme.textTheme.bodyMedium!.copyWith(fontSize: 20),
              onChanged: (value) {
                ref.read(popupMenuClearTextOpenProvider).call();
                if (ref.read(splitModeProvider))
                  ref.read(selectedWordIdProvider.notifier).changeSelectedId =
                      -1;
                if (value.isEmpty) {
                  ref.read(translateModeProvider.notifier).setFalse();
                } else {
                  ref.read(translateModeProvider.notifier).setTrue();
                }
                ref.read(textFieldValueProvider.notifier).onChangeText = value;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.only(top: 10),
                hintText: tr('enter_the_word'),
                hintStyle: theme.brightness == Brightness.dark
                    ? theme.textTheme.bodyMedium!.copyWith(
                        color:
                            theme.textTheme.bodySmall!.color!.withOpacity(0.6),
                        fontSize: 18,
                        fontWeight: FontWeight.w500)
                    : theme.textTheme.bodyMedium!.copyWith(
                        color:
                            theme.textTheme.bodySmall!.color!.withOpacity(0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                suffixIconConstraints: const BoxConstraints(maxHeight: 24),
                suffixIcon: (ref.watch(translateModeProvider))
                    ? SizedBox(
                        width: 35,
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 30,
                          onPressed: () {
                            ref.read(textFieldValueProvider.notifier).state =
                                '';
                            ref.read(translateModeProvider.notifier).setFalse();
                            textController.clear();
                          },
                          icon: Icon(Icons.close,
                              color: theme.textTheme.bodySmall!.color!
                                  .withOpacity(0.6),
                              size: 32),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            Container(
              height: 2,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 3, top: 3),
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
