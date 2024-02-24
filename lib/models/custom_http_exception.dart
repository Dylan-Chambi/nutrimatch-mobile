class CustomHTTPException implements Exception {
  final String detail;
  final int statusCode;

  CustomHTTPException(this.detail, this.statusCode);

  @override
  String toString() {
    return detail;
  }
}
