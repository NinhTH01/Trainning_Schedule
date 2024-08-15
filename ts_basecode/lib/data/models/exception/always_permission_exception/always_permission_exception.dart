class AlwaysPermissionException implements Exception {
  final String message;

  AlwaysPermissionException(this.message);
}
