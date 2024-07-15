import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pdf_dto.g.dart';

@JsonSerializable()
class PdfDto {
  final String title;
  final String url;
  final double version;
  final String description;

  PdfDto({
    required this.title,
    required this.url,
    required this.version,
    required this.description,
  });

  factory PdfDto.fromJson(Map<String, dynamic> json) => _$PdfDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PdfDtoToJson(this);

  Pdf toPdf() =>
      Pdf(title: title, url: url, version: version, description: description);
}
