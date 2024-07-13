// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PdfDto _$PdfDtoFromJson(Map<String, dynamic> json) => PdfDto(
      title: json['title'] as String,
      url: json['url'] as String,
      version: (json['version'] as num).toDouble(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$PdfDtoToJson(PdfDto instance) => <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'version': instance.version,
      'description': instance.description,
    };
