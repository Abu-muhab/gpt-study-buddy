class AppValidators {
  static String? Function(String?) requiredString(String message) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return message;
      }
      return null;
    };
  }
}
