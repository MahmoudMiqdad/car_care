class RequestImageModel {
  final int? id;
  final String? url;

  RequestImageModel({this.id, this.url});

  factory RequestImageModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RequestImageModel();

    return RequestImageModel(
      id: json['id'],
      url: json['url'],
    );
  }
}