class BouteilleException implements Exception {
  final String message;

  BouteilleException(this.message);

  @override
  String toString() {
    return 'BouteilleException: $message';
  }
}