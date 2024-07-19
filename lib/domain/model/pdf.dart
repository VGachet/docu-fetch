import 'package:floor/floor.dart';

@entity
class Pdf {
  @primaryKey
  final String? id;
  final String title;
  final String? path;
  final String url;

  final double version;
  final String description;
  int lastPageOpened = 0;

  Pdf(
      {this.id,
      required this.title,
      this.path,
      required this.url,
      required this.version,
      required this.description});

  Pdf copyWith({
    String? id,
    String? title,
    String? path,
    String? url,
    double? version,
    String? description,
    int? lastPageOpened,
  }) =>
      Pdf(
          id: id ?? this.id,
          title: title ?? this.title,
          path: path ?? this.path,
          url: url ?? this.url,
          version: version ?? this.version,
          description: description ?? this.description);
}
