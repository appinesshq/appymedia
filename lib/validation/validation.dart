abstract class Validation {
  String validateEmail(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!value.contains(RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String validatePassword(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return 'Password can\'t be empty';
    } else if (value.length < 6) {
      return 'Length of password should be greater than 6';
    }

    return null;
  }

  String validatePasswordConfirm(String value, String other) {
    if (value.isEmpty) return 'Password confirmation can\'t be empty';
    if (value != other) return 'Pasword confirmation doesn\'t match password';

    return null;
  }
}
