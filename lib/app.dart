import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/db_helper.dart';
import 'navigator/navigate_effect.dart';
import 'presentation/pages/home_page/home_page.dart';
import 'presentation/pages/home_page/home_page_model.dart';
import 'presentation/pages/word_page/word_page_model.dart';
import 'presentation/providers/history.dart';
import 'presentation/providers/search.dart';
import 'presentation/providers/search_mode.dart';

const primaryColor = Color.fromARGB(255, 35, 73, 118);

const fontFamilyName = 'BrisaSans';

class MyApp extends StatelessWidget {
  const MyApp(this.savedThemeMode, {super.key});
  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      key: const Key('adaptive_theme'),
      light: ThemeData.light(useMaterial3: false).copyWith(
        visualDensity: VisualDensity.standard,
        textTheme: TextTheme(
          displaySmall: ThemeData.light()
              .textTheme
              .displaySmall!
              .copyWith(fontFamily: fontFamilyName),
          displayMedium: ThemeData.light()
              .textTheme
              .displayMedium!
              .copyWith(fontFamily: fontFamilyName),
          displayLarge: ThemeData.light()
              .textTheme
              .displayLarge!
              .copyWith(fontFamily: fontFamilyName),
          bodySmall: ThemeData.light()
              .textTheme
              .bodySmall!
              .copyWith(fontFamily: fontFamilyName),
          bodyMedium: ThemeData.light()
              .textTheme
              .bodyMedium!
              .copyWith(fontFamily: fontFamilyName),
          bodyLarge: ThemeData.light()
              .textTheme
              .bodyLarge!
              .copyWith(fontFamily: fontFamilyName),
          titleSmall: ThemeData.light()
              .textTheme
              .titleSmall!
              .copyWith(fontFamily: fontFamilyName),
          titleMedium: ThemeData.light()
              .textTheme
              .titleMedium!
              .copyWith(fontFamily: fontFamilyName),
          titleLarge: ThemeData.light()
              .textTheme
              .titleLarge!
              .copyWith(fontFamily: fontFamilyName),
          labelSmall: ThemeData.light()
              .textTheme
              .labelSmall!
              .copyWith(fontFamily: fontFamilyName),
          labelMedium: ThemeData.light()
              .textTheme
              .labelMedium!
              .copyWith(fontFamily: fontFamilyName),
          labelLarge: ThemeData.light()
              .textTheme
              .labelLarge!
              .copyWith(fontFamily: fontFamilyName),
          headlineSmall: ThemeData.light()
              .textTheme
              .headlineSmall!
              .copyWith(fontFamily: fontFamilyName),
          headlineMedium: ThemeData.light()
              .textTheme
              .headlineMedium!
              .copyWith(fontFamily: fontFamilyName),
          headlineLarge: ThemeData.light()
              .textTheme
              .headlineLarge!
              .copyWith(fontFamily: fontFamilyName),
        ),
        indicatorColor: primaryColor,
        hoverColor: primaryColor,
        textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.blue.withOpacity(0.3),
            selectionHandleColor: Colors.blue,
            cursorColor: Colors.blue),
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
            titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
            iconTheme: IconThemeData(
              color: Colors.white,
            )),
        canvasColor: Colors.white,
        primaryColor: primaryColor,
        dialogBackgroundColor: Colors.white,
        dialogTheme: DialogThemeData(
       
          backgroundColor: Colors.white,
        ),
        radioTheme: RadioThemeData(
          // fillColor: MaterialStateProperty.all(Colors.blue),
          overlayColor: MaterialStateProperty.all(Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      dark: ThemeData.dark(useMaterial3: false).copyWith(
        visualDensity: VisualDensity.standard,
        textTheme: TextTheme(
          displaySmall: ThemeData.dark()
              .textTheme
              .displaySmall!
              .copyWith(fontFamily: fontFamilyName),
          displayMedium: ThemeData.dark()
              .textTheme
              .displayMedium!
              .copyWith(fontFamily: fontFamilyName),
          displayLarge: ThemeData.dark()
              .textTheme
              .displayLarge!
              .copyWith(fontFamily: fontFamilyName),
          bodySmall: ThemeData.dark()
              .textTheme
              .bodySmall!
              .copyWith(fontFamily: fontFamilyName),
          bodyMedium: ThemeData.dark()
              .textTheme
              .bodyMedium!
              .copyWith(fontFamily: fontFamilyName),
          bodyLarge: ThemeData.dark()
              .textTheme
              .bodyLarge!
              .copyWith(fontFamily: fontFamilyName),
          titleSmall: ThemeData.dark()
              .textTheme
              .titleSmall!
              .copyWith(fontFamily: fontFamilyName),
          titleMedium: ThemeData.dark()
              .textTheme
              .titleMedium!
              .copyWith(fontFamily: fontFamilyName),
          titleLarge: ThemeData.dark()
              .textTheme
              .titleLarge!
              .copyWith(fontFamily: fontFamilyName),
          labelSmall: ThemeData.dark()
              .textTheme
              .labelSmall!
              .copyWith(fontFamily: fontFamilyName),
          labelMedium: ThemeData.dark()
              .textTheme
              .labelMedium!
              .copyWith(fontFamily: fontFamilyName),
          labelLarge: ThemeData.dark()
              .textTheme
              .labelLarge!
              .copyWith(fontFamily: fontFamilyName),
          headlineSmall: ThemeData.dark()
              .textTheme
              .headlineSmall!
              .copyWith(fontFamily: fontFamilyName),
          headlineMedium: ThemeData.dark()
              .textTheme
              .headlineMedium!
              .copyWith(fontFamily: fontFamilyName),
          headlineLarge: ThemeData.dark()
              .textTheme
              .headlineLarge!
              .copyWith(fontFamily: fontFamilyName),
        ),
        brightness: Brightness.dark,
        drawerTheme: const DrawerThemeData(
            backgroundColor: Color.fromARGB(255, 0, 0, 0)),
        appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
            titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
            iconTheme: IconThemeData(
              color: Colors.white,
            )),
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        primaryColor: primaryColor,
        indicatorColor: primaryColor,
        hoverColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(Colors.blue),
        ),
        textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.blue.withOpacity(0.3),
            selectionHandleColor: Colors.blue,
            cursorColor: Colors.blue),
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        dialogTheme: DialogThemeData(
          
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        home: const AppInit(),
        debugShowCheckedModeBanner: false,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
      ),
    );
  }
}

class AppInit extends ConsumerStatefulWidget {
  const AppInit({super.key});

  @override
  ConsumerState<AppInit> createState() => _AppInitState();
}

class _AppInitState extends ConsumerState<AppInit> {
  @override
  void initState() {
    _initProviders();
    super.initState();
  }

  Future<void> _initProviders() async {
    // await ref.read(searchModeProvider.future);
    await ref.read(databaseProvider.future);
    await ref.read(searchModeProvider.notifier).init();

    await Future.wait([
      Future.delayed(const Duration(milliseconds: 500)),
      ref.read(historyProvider.future),
      ref.read(splitModeProvider.notifier).init(),
      ref.read(articleZoomProvider.notifier).init(),
      ref.read(glossaryZoomProvider.notifier).init(),
    ]);
    Navigator.of(context).pushReplacement(
        NavigateEffects.fadeTransitionToPage(const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.brightness == Brightness.dark
          ? const Color.fromRGBO(47, 47, 47, 1)
          : const Color.fromARGB(255, 255, 255, 255),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black.withOpacity(.2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/playstore-icon.png',
              width: 120,
            ),
          ),
        ),
      ),
    );
  }
}
