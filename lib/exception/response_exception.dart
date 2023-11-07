class ResponseException implements Exception {
  final String? message;
  final int code;

  ResponseException(this.message, this.code);
}
