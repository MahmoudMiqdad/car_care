class MetaModel {
  final int? total;
  final int? perPage;
  final int? currentPage;

  MetaModel({this.total, this.perPage, this.currentPage});

  factory MetaModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MetaModel();

    return MetaModel(
      total: json["total"],
      perPage: json["per_page"],
      currentPage: json["current_page"],
    );
  }
}