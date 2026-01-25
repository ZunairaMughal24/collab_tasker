class Validators {
  static String? emptyValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please fill in this field';
    }
    return null;
  }

  static String? emailValidator(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Please Enter your email';
    }

    const p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final regExp = RegExp(p);

    if (!regExp.hasMatch(email.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Please enter your password';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? nameValidator(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Please enter your name';
    }

    if (name.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }
}
