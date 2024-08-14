import 'package:floor/floor.dart';

@entity
class Repository {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String url;
  final String? name;

  Repository({required this.url, this.id, this.name});
}
