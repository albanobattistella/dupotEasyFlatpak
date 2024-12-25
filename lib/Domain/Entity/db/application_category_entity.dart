class ApplicationCategoryEntity {
  // ignore: non_constant_identifier_names
  final String appstream_id;
  // ignore: non_constant_identifier_names
  final String category_id;

  ApplicationCategoryEntity({
    // ignore: non_constant_identifier_names
    required this.appstream_id,
    // ignore: non_constant_identifier_names
    required this.category_id,
  });

  Map<String, Object?> toMap() {
    return {
      'appstream_id': appstream_id,
      'category_id': category_id,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'ApplicationCategoryEntity{appstream_id: $appstream_id, category_id: $category_id }';
  }
}
