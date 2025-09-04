import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_model.g.dart';

@JsonSerializable()
class WordModel extends Equatable {
  final int id;
  final String title;
  final String translate;
  final String? body;
  @JsonKey(name: 'audio_url')
  final String? audioUrl;
  final Map<String, int>? refs;
  final String? dict;
  final int? translationId;

  const WordModel({
    required this.id,
    required this.title,
    required this.body,
    required this.audioUrl,
    required this.refs,
    required this.dict,
    required this.translate,
    required this.translationId,
  });

  @override
  List<Object> get props => [id, title, translate, body ?? ''];

  factory WordModel.fromJson(Map<String, dynamic> json) {
    // if (json['body'] != null) {
    //   final bodyList = base64.decode(json['body'] as String);
    //   body = utf8.decode(bodyList);
    // }
    return WordModel(
      id: json['id'] as int,
      title: json['title'] as String,
      translate: json['translation'] as String,
      body: json['body'] as String?,
      audioUrl: json['audio_url'] as String?,
      refs: (json['refs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as int),
      ),
      dict: json['dict'] as String?,
      translationId: json['trn_id'] as int?,
    );
  }
}
