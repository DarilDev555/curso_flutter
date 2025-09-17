class WrongCredentials implements Exception {}

class InvalidToken implements Exception {}

class ConnectionTimeout implements Exception {}

class CustomError implements Exception {
  final String message;
  //final int errorCode;

  CustomError({required this.message});
}

class FormErrorsListErros implements Exception {
  final Map<String, List<String>> errors;

  FormErrorsListErros({required this.errors});
}

class FormErrorsStrings implements Exception {
  final Map<String, String> errors;

  FormErrorsStrings({required this.errors});
}
