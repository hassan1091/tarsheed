sealed class CustomException implements Exception {
  final String message;

  const CustomException([this.message = 'Unexpected error']);

  @override
  String toString() => message;
}

/// Exception for weak passwords.
class WeakPasswordException extends CustomException {
  const WeakPasswordException({String message = 'Weak password exception.'})
      : super(message);
}

/// Exception for email already in use.
class EmailAlreadyInUseException extends CustomException {
  const EmailAlreadyInUseException(
      {String message = 'Email is already in use.'})
      : super(message);
}
