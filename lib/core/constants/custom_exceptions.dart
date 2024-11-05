sealed class CustomException implements Exception {
  final String message;

  const CustomException([this.message = 'Unexpected error']);

  @override
  String toString() => message;
}

/// Exception for uncategorized or general exception
class PublicException extends CustomException {
  const PublicException(super.message);
}

/// Exception for device link to the same user exists
class DeviceLinkExistsException extends CustomException {
  const DeviceLinkExistsException(
      {String message = "Device link already exists."});
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

/// Exception for when a user is not found in the system.
class UserNotFoundException extends CustomException {
  const UserNotFoundException(
      {String message = 'No user found for that email.'})
      : super(message);
}

/// Exception for incorrect password attempts.
class WrongPasswordException extends CustomException {
  const WrongPasswordException(
      {String message = 'Wrong password provided for that user.'})
      : super(message);
}
