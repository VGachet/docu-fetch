import 'package:floor/floor.dart';

@entity
class Pdf {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String? renamedTitle;
  final String? path;
  final String? url;
  final double version;
  final String? description;
  int lastPageOpened = 0;

  Pdf(
      {this.id,
      required this.title,
      this.renamedTitle,
      this.path,
      this.url,
      required this.version,
      this.description});

  String getTitle() {
    return renamedTitle ?? title;
  }

  Pdf copyWith({
    int? id,
    String? title,
    String? renamedTitle,
    String? path,
    String? url,
    double? version,
    String? description,
    int? lastPageOpened,
  }) =>
      Pdf(
          id: id ?? this.id,
          title: title ?? this.title,
          renamedTitle: renamedTitle ?? this.renamedTitle,
          path: path ?? this.path,
          url: url ?? this.url,
          version: version ?? this.version,
          description: description ?? this.description);
}
