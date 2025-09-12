import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'textfield_provider.g.dart';

@Riverpod(keepAlive: true)
class TextFieldValue extends _$TextFieldValue {
  @override
  String build() => '';

  final FocusNode _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;

  set onChangeText(String value) => state = value;
  
  void clearText() {
    state = '';
    textController.clear();
  }
}

final textController = TextEditingController();

// Provider для отслеживания состояния popup меню
final popupMenuOpenProvider = StateProvider<bool>((ref) => false);
final popupMenuClearTextOpenProvider = StateProvider<Function()>((ref) => (){});
// Глобальная функция для закрытия всех открытых popup меню


