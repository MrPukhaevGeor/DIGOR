import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upgrader/upgrader.dart';

import '../../providers/textfield_provider.dart';
import '../word_page/word_page.dart';
import 'components/app_bar_widget.dart';
import 'components/drawer_widget.dart';
import 'components/last_translations_widget.dart';
import 'components/search_textfield.dart';
import 'components/word_list_widget.dart';
import 'home_page_model.dart';

GlobalKey<ScaffoldState> homePageKey = GlobalKey();

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UpgradeAlert(
      child: WillPopScope(
        onWillPop: () async {
          // Проверяем, есть ли открытое popup меню
          final isPopupOpen = ref.read(popupMenuOpenProvider);
          print(" isPopupOpen $isPopupOpen");
          if (isPopupOpen) {
            // Закрываем popup меню
            ref.read(popupMenuClearTextOpenProvider).call();
            ref.read(popupMenuOpenProvider.notifier).state = false;
            return false; // Не выходим из приложения
          }

          // Проверяем состояние текстового поля
          final textFieldValue = ref.read(textFieldValueProvider);
          if (textFieldValue.isNotEmpty) {
            ref.read(textFieldValueProvider.notifier).state = '';
            ref.read(translateModeProvider.notifier).setFalse();
            textController.clear();
            return false; // Не выходим из приложения
          }

          // Если всё пусто и ничего не открыто - разрешаем выход
          return true;
        },
        child: Scaffold(
          key: homePageKey,
          resizeToAvoidBottomInset: false,
          drawer: const DrawerWidget(),
          body: Column(
            children: [
              AppBarWidget(
                scaffoldKey: homePageKey,
              ),
              Expanded(
                child: Column(
                  children: [
                    SearchTextfield(),
                    LastTranslationsWidget(),
                    WordListWidget(),
                  ],
                ),
              ),
              if (ref.watch(splitModeProvider)) ...[
                SizedBox(
                    height: 2,
                    child: Divider(
                        thickness: 2, color: Theme.of(context).primaryColor)),
                Expanded(
                  child: WordPage(ref.watch(selectedBottomPanelWordIdProvider),
                      needAppBar: false),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
