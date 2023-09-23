class DomainException implements Exception {
  late final String message;

  DomainException(String? message) {
    this.message = message ?? 'An error occurred';
  }
}
