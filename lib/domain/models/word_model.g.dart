// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordModel _$WordModelFromJson(Map<String, dynamic> json) => WordModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String?,
      audioUrl: json['audio_url'] as String?,
      refs: (json['refs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      dict: json['dict'] as String?,
      translate: json['translate'] as String,
      translationId: (json['translationId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WordModelToJson(WordModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'translate': instance.translate,
      'body': instance.body,
      'audio_url': instance.audioUrl,
      'refs': instance.refs,
      'dict': instance.dict,
      'translationId': instance.translationId,
    };
