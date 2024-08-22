import 'package:floor/floor.dart';

@entity
class Folder {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final int? parentFolder;
  int order;

  Folder(
      {required this.title, required this.order, this.id, this.parentFolder});

  Folder copyWith({
    int? id,
    String? title,
    int? parentFolder,
    int? order,
  }) =>
      Folder(
          title: title ?? this.title,
          order: order ?? this.order,
          parentFolder: parentFolder ?? this.parentFolder,
          id: id ?? this.id);
}
