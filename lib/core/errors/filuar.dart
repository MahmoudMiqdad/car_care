class Failure {
  final String message;
  final Map<String, List<String>>? errors;

  const Failure({
    required this.message,
    this.errors,
  });

  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(
      message: json['message'] ?? "حدث خطأ غير معروف",
      errors: _parseErrors(json['errors']),
    );
  }

  Object? get data => null;

  static Map<String, List<String>>? _parseErrors(dynamic errorsJson) {
    if (errorsJson == null) return null;

    if (errorsJson is Map<String, dynamic>) {
      return errorsJson.map(
        (key, value) => MapEntry(
          key,
          List<String>.from(value),
        ),
      );
    }

    return null;
  }
}