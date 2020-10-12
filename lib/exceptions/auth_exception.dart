class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "This e-mail is already in use.",
    "OPERATION_NOT_ALLOWED": "Unauthorized operation.",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "Too many login attempts, try again later.",
    "EMAIL_NOT_FOUND": "E-mail not found.",
    "INVALID_PASSWORD": "Incorrect password.",
    "USER_DISABLED": "This user is deactivated.",
  };

  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    if(errors.containsKey(key)) {
      return errors[key];
    }
    return "An unknown error has occurred.";
  }
}