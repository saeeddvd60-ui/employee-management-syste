class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'ایمیل را وارد کنید';
    }
    final emailRegex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'ایمیل معتبر نیست';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'شماره تماس را وارد کنید';
    }
    if (value.length < 10) {
      return 'شماره تماس حداقل 10 رقم است';
    }
    return null;
  }

  static String? validateNationalId(String? value) {
    if (value == null || value.isEmpty) {
      return 'شماره ملی را وارد کنید';
    }
    if (value.length != 10) {
      return 'شماره ملی باید 10 رقم باشد';
    }
    return null;
  }

  static String? validateEmployeeCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'کد پرسنل را وارد کنید';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'نام را وارد کنید';
    }
    if (value.length < 2) {
      return 'نام حداقل 2 کاراکتر است';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'نام کاربری را وارد کنید';
    }
    if (value.length < 3) {
      return 'نام کاربری حداقل 3 کاراکتر است';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز عبور را وارد کنید';
    }
    if (value.length < 6) {
      return 'رمز عبور حداقل 6 کاراکتر است';
    }
    return null;
  }

  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'زمان را وارد کنید';
    }
    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(value)) {
      return 'فرمت زمان صحیح نیست (HH:MM)';
    }
    return null;
  }

  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'این فیلد الزامی است';
    }
    return null;
  }
}
