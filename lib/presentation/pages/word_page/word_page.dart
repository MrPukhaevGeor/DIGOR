import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/search.dart';
import '../../providers/search_mode.dart';
import '../socket_exception_widget.dart';
import 'components/app_bar_widget.dart';
import 'components/side_menu_buttons.dart';
import 'components/styled_text_widget.dart';
import 'components/title_widget.dart';
import 'word_page_model.dart';

class WordPage extends ConsumerWidget {
  final int id;
  final bool needAppBar;
  WordPage(this.id, {super.key, this.needAppBar = true});



  void _onPointerDown(PointerEvent event) {
      _fingerCount++;
      if(_fingerCount > 1) {
        canScroll = false;
      }
      print(canScroll);
      updateStreamController.add(canScroll);

  }

  void _onPointerUp(PointerEvent event) {
      _fingerCount--;
      canScroll = true;
      print(canScroll);

      updateStreamController.add(canScroll);


  }

  void _onPointerCancel(PointerEvent event) {

      _fingerCount = 0;
      canScroll = true;
      print(canScroll);

      updateStreamController.add(canScroll);

  }

  int _fingerCount = 0;
  bool canScroll = true;

  final StreamController<bool> updateStreamController = StreamController<bool>();

  Widget interactive ({required bool canScroll, required Widget child}) {
    return InteractiveViewer(child: child);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == -1) {
      return Center(child: Text(tr('nothing_select')));
    }
    final theme = Theme.of(context);
    final wordProvider = ref.watch(fetchWordProvider(id));
    return StreamBuilder(
      stream: updateStreamController.stream,
      builder: (context, snapshot) =>  wordProvider.when(
        data: (word) {
          if (word == null) return const Center(child: Text('Слово не найдено'));

          return Scaffold(
            appBar: needAppBar
                ? PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight), child: WordPageAppBar(body: word.body ?? ''))
                : null,
            body: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1, boldText: false),
              child: Stack(
                children: [
                  Listener(
                    onPointerDown: _onPointerDown,
                    onPointerUp: _onPointerUp,
                    onPointerCancel: _onPointerCancel,
                    child: interactive(
                      canScroll: snapshot.data ?? true,
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            physics: (snapshot.data ?? true) ? null : const NeverScrollableScrollPhysics(),

                            child: Column(
                              children: [
                                const DictionaryNameWidget(),
                                SizedBox(height: 1, child: Divider(thickness: 1, color: theme.primaryColor.withOpacity(.5))),
                                const SizedBox(height: 18),
                                TitleWidget(word.title, word.audioUrl),
                                const SizedBox(height: 28),
                                StyledTextWidget(
                                  word: word,
                                  isShowingExamples: ref.watch(exampleModeProvider) == ExampleModeEnum.show,
                                ),
                              ] ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SideMenuButtons(wordModel: word),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => Scaffold(
          appBar: needAppBar ? AppBar(title: Text(tr('Error'))) : null,
          body: error is DioError && error.error is SocketException
              ? SocketExceptionWidget(() => ref.refresh(fetchWordProvider(id)), true)
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(tr('something_went_wrong')),
                  ),
                ),
        ),
        loading: () => Scaffold(
          appBar: needAppBar ? AppBar(title: Text(tr('translation'))) : null,
          body: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class DictionaryNameWidget extends ConsumerWidget {
  const DictionaryNameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final zoom = ref.watch(articleZoomProvider);
    final dicName = ref.read(searchModeProvider.notifier).getFullLanguageMode();
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 14),
      child: Text(
        'Essential ($dicName)',
        style: theme.textTheme.bodyLarge!.copyWith(
          fontSize: 17 * zoom,
          fontFamily: 'HelveticaNeue',
        ),
      ),
    );
  }
}
