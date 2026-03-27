class RequestImageModel {
  final int id;
  final String url;

  RequestImageModel({
    required this.id,
    required this.url,
  });

  factory RequestImageModel.fromJson(Map<String, dynamic> json) {
    return RequestImageModel(
      id: json['id'],
      url: json['url'],
    );
  }

}