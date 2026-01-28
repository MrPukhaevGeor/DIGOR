import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
        Locale('tr', 'TR'),
        Locale('sw', 'SW'),
        Locale('km', 'KM')
      ],
      path: 'lang',
      fallbackLocale: const Locale('ru', 'RU'),
      child: ProviderScope(
        child: MyApp(savedThemeMode),
      ),
    ),
  );
}

class IsActiveLicense extends StatelessWidget {
  const IsActiveLicense({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Пожалуйста, оплатите работу разработчика"),
        ),
      ),
    );
  }
}
