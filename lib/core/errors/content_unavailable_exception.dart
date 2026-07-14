class ContentUnavailableException implements Exception {
  final String message;
  const ContentUnavailableException(this.message);

  @override
  String toString() => message;
}