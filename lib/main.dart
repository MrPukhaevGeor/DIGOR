import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

Future<bool> fetchLicense() async {
  const key = "isActiveLicense";
  final url = Uri.parse(
    "https://secure.plra.ru/?query=OtQwmiLQxYrNyM72gv6dnLkv4QYrDE",
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final isActive = data['data']['isActive'] as bool;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, isActive);

      return isActive;
    } else {

      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key) ?? true; 
    }
  } catch (e) {

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await EasyLocalization.ensureInitialized();
  final isActive = await fetchLicense();
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
        child: isActive ? MyApp(savedThemeMode) : const IsActiveLicense(),
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
