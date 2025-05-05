class WrongCredentials implements Exception {}

class InvalidToken implements Exception {}

class ConnectionTimeout implements Exception {}

class CustomError implements Exception {
  final String message;
  //final int errorCode;

  CustomError({required this.message});
}

class FormErrors implements Exception {
  final Map<String, List<String>> errors;

  FormErrors({required this.errors});
}
