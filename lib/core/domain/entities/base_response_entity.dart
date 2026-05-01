class BaseResponseEntity {
  final bool success;
  final String message;

  const BaseResponseEntity({
    required this.success,
    required this.message,
  });
}