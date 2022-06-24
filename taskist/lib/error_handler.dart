class ErrorHandler {
  static String getError(String error) {
    if (error.contains('UNIQUE')) {
      return ' cannot be duplicated';
    } else {
      return 'Error happendns';
    }
  }
}
