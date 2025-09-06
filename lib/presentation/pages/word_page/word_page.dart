import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_viewer_2/interactive_viewer_2.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/tags/styled_text_tag_action.dart';

import 'package:webview_flutter/webview_flutter.dart';
import '../../../domain/models/word_model.dart';
import '../../../navigator/navigate_effect.dart';
import '../../../outside_functions.dart';
import '../../providers/search.dart';
import '../../providers/search_mode.dart';
import '../home_page/home_page_model.dart';
import '../socket_exception_widget.dart';
import 'components/app_bar_widget.dart';
import 'components/side_menu_buttons.dart';
import 'components/styled_text_to_html.dart';
import 'components/styled_text_widget.dart';
import 'components/title_widget.dart';
import 'word_page_model.dart';

class WordPage extends ConsumerWidget {
  final int id;
  final bool needAppBar;

  WordPage(this.id, {super.key, this.needAppBar = true});


  bool canScroll = true;

  final StreamController<bool> updateStreamController = StreamController<
      bool>();

  Widget interactive({required bool canScroll, required Widget child}) {
    if (false)
      return SingleChildScrollView(
          physics: null,
          child: child);
    return SingleChildScrollView(child: child);
  }

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == -1) {
      return Center(child: Text(tr('nothing_select')));
    }

    final wordProvider = ref.watch(fetchWordProvider(id));
    return wordProvider.when(
      data: (word) {
        if (word == null) return const Center(child: Text('Слово не найдено'));

        return Scaffold(
          appBar: needAppBar
              ? PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: WordPageAppBar(body: word.body ?? ''))
              : null,
          body: GestureDetector(
            onTap: () {
              print('unfocus');
              FocusScope.of(context).unfocus();
            },
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1, boldText: false),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: interactive(
                      canScroll: false,
                      child: Container(
                        color: Colors.transparent,
                        child: Builder(
                          builder: (context,) =>
                              Padding(padding: const EdgeInsets.all(16),
                                child: Container(
                                  color: Colors.transparent,
                                  constraints: BoxConstraints(
                                      minHeight: MediaQuery
                                          .sizeOf(context)
                                          .height - 195,
                                      maxHeight: double.infinity
                                  ),

                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width - 50,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [

                                                /*const DictionaryNameWidget(),
                                              SizedBox(height: 1, child: Divider(thickness: 1, color: theme.primaryColor.withOpacity(.5))),
                                              const SizedBox(height: 18),*/
                                                if(word.audioUrl != null)
                                                  TitleWidget(word.title,
                                                      word.audioUrl),
                                                if(word.audioUrl != null)

                                                  const SizedBox(height: 28),
                                                Container(
                                                  color: Colors.transparent,
                                                  child: StyledTextWidget(
                                                    word: word,
                                                    isShowingExamples: ref
                                                        .watch(
                                                        exampleModeProvider) ==
                                                        ExampleModeEnum.show,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),

                  SideMenuButtons(wordModel: word),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) =>
          Scaffold(
            appBar: needAppBar ? AppBar(title: Text(tr('Error'))) : null,
            body: error is DioError && error.error is SocketException
                ? SocketExceptionWidget(() =>
                ref.refresh(fetchWordProvider(id)), true)
                : Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(tr('something_went_wrong')),
              ),
            ),
          ),
      loading: () =>
          Scaffold(
            appBar: needAppBar ? AppBar(title: Text(tr('translation'))) : null,
            body: const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}

