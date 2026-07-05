# 🚀 دستور‌العمل نصب و اجرا برای اندروید

## ✅ پیش‌نیازها

برای اجرای این پروژه روی اندروید، شما نیاز به:

### 1️⃣ **Flutter SDK** نصب کنید
- دانلود از: https://flutter.dev/docs/get-started/install
- **Windows**: دانلود فایل ZIP و Extract کنید
- متغیر محیط `PATH` را تنظیم کنید

### 2️⃣ **Android Studio** نصب کنید
- دانلود از: https://developer.android.com/studio
- نصب کنید و تمام پیغام‌های نصب را دنبال کنید

### 3️⃣ **Git** نصب کنید (اختیاری)
- دانلود از: https://git-scm.com/

---

## 📥 مرحله 1: دانلود پروژه

### روش 1: با Git
```bash
git clone https://github.com/saeeddvd60-ui/employee-management-syste.git
cd employee-management-syste
```

### روش 2: بدون Git
- برو به: https://github.com/saeeddvd60-ui/employee-management-syste
- کلیک بر روی **Code** (دکمه سبز)
- کلیک بر روی **Download ZIP**
- Extract کنید و فایل را باز کنید

---

## 🔧 مرحله 2: نصب وابستگی‌ها

در **Command Prompt** یا **PowerShell**:

```bash
cd <مسیر پروژه>
flutter pub get
```

**نتیجه**: تمام package‌ها نصب می‌شوند (چند دقیقه طول می‌کشد)

---

## 📱 مرحله 3: اجرا روی گوشی یا Emulator

### گزینه 1️⃣: اجرا روی گوشی واقعی (بهترین روش)

#### Step 1: Enable USB Debugging
1. گوشی‌تان را باز کنید
2. برو به **Settings** > **About phone**
3. دستور **Build number** را 7 بار لمس کنید (تا Develop mode فعال شود)
4. برو به **Settings** > **System** > **Developer Options**
5. **USB Debugging** را فعال کنید
6. گوشی را به کامپیوتر متصل کنید
7. اجازه دسترسی را بدهید

#### Step 2: اجرا
```bash
flutter devices          # چک کنید که گوشی دیده شود
flutter run             # شروع اجرا
```

**نتیجه**: اپ روی گوشی شما نصب و اجرا می‌شود! 🎉

---

### گزینه 2️⃣: اجرا روی Android Emulator

#### Step 1: Emulator را باز کنید
```bash
flutter emulators              # لیست emulator‌ها
flutter emulators --launch <name>  # شروع emulator
```

#### Step 2: اجرا
```bash
flutter run
```

**نتیجه**: اپ روی emulator اجرا می‌شود

---

## 🔐 اطلاعات ورود

وقتی اپ باز شد:

| فیلد | مقدار |
|------|-------|
| **Username** | `admin` |
| **Password** | `admin123` |

---

## 📊 بعد از ورود چی می‌بینید؟

✅ **Dashboard** - آمار حضور و غیبت امروز  
✅ **مدیریت پرسنل** - افزودن/ویرایش/حذف پرسنل  
✅ **ثبت حضور** - check-in/check-out  
✅ **مدیریت مرخصی** - درخواست و تاییدمرخصی  
✅ **گزارش‌ها** - آمار‌های دقیق (در توسعه)  

---

## 🛠️ دستورات مفید

```bash
# چک کنید Flutter درست نصب شده
flutter doctor

# لیست دستگاه‌های متصل
flutter devices

# حذف build قدیمی
flutter clean

# نصب دوباره
flutter pub get

# اجرا در حالت Release (سریع‌تر)
flutter run --release

# Build APK (فایل نصبی)
flutter build apk
```

---

## ❌ مشکلات رایج و حل آن‌ها

### مشکل 1: `flutter command not found`
**راه‌حل:**
- Flutter SDK را از https://flutter.dev دانلود کنید
- PATH را تنظیم کنید: `C:\flutter\bin`
- Command Prompt را دوباره باز کنید

### مشکل 2: `No connected devices`
**راه‌حل:**
- USB Debugging را فعال کنید
- Driver USB روی Windows را نصب کنید
- یا Emulator را شروع کنید

### مشکل 3: `Gradle build failed`
**راه‌حل:**
```bash
flutter clean
flutter pub get
flutter run
```

### مشکل 4: `Waiting for another flutter command to release the startup lock`
**راه‌حل:**
```bash
cd <مسیر پروژه>\android
del -r .gradle
cd ..
flutter run
```

---

## 📲 ساختن APK برای توزیع

برای فروختن یا اشتراک‌گذاری اپ:

```bash
flutter build apk
```

فایل APK در اینجا قرار می‌گیرد:
```
<مسیر پروژه>\build\app\outputs\flutter-apk\app-release.apk
```

این فایل را می‌توانید:
- روی گوشی نصب کنید
- به دوستان بفرستید
- روی Google Play آپلود کنید

---

## 🆘 نیاز به کمک؟

اگر مشکلی داشتید:
1. چک کنید Flutter به‌درستی نصب شده (`flutter doctor`)
2. USB Cable خوب متصل باشد
3. USB Debugging فعال باشد
4. اینترنت خوب باشد

---

## 📚 منابع مفید

- 📖 [Flutter Docs](https://flutter.dev/docs)
- 🤖 [Android Studio Docs](https://developer.android.com/studio)
- 💡 [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)

---

**نسخه:** 1.0.0  
**آخرین به‌روزرسانی:** 2026-07-05  
**توسعه‌دهنده:** Saeed
