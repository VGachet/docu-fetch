class Pdf {
  final String title;
  final String? path;
  final String url;
  final double version;
  final String description;
  final int lastPageOpened = 0;

  Pdf(
      {required this.title,
      this.path,
      required this.url,
      required this.version,
      required this.description});

  Pdf copyWith({
    String? title,
    String? path,
    String? url,
    double? version,
    String? description,
    int? lastPageOpened,
  }) =>
      Pdf(
          title: title ?? this.title,
          path: path ?? this.path,
          url: url ?? this.url,
          version: version ?? this.version,
          description: description ?? this.description);
}
