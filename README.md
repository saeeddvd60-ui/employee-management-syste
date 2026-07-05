# سیستم مدیریت حضور و کارکرد پرسنل
# Employee Management & Attendance System

## 📋 توضیحات
سیستم جامع و تکامل‌یافته برای مدیریت پرسنل، ثبت ورود/خروج، غیبت، مرخصی، کارکرد و گزارش‌های تفصیلی.

**نسخه:** 1.0.0  
**توسعه‌دهنده:** Saeed  
**تاریخ ایجاد:** 2026

---

## ✨ ویژگی‌های اصلی

### 👥 مدیریت پرسنل
- ✅ ثبت اطلاعات پرسنل (نام، شماره ملی، شماره تماس، جنسیت)
- ✅ تعریف قرارداد کاری (ساعت شروع/پایان، روزهای کاری)
- ✅ مدیریت شعبه‌ها (4 شعبه)
- ✅ سطح دسترسی (مدیر، سرپرست، پرسنل عادی)

### 📅 مدیریت حضور و غیبت
- ✅ ثبت خودکار ورود و خروج (با ساعت و تاریخ)
- ✅ ثبت غیبت
- ✅ ثبت مرخصی (سالانه، استعلاجی، بی‌حقوق)
- ✅ ثبت روزهای تعطیل و آفِ
- ✅ ثبت استعلاجی (بیمار)

### ⏱️ محاسبه کارکرد
- ✅ کارکرد عادی (روزهای معمول)
- ✅ کارکرد روزهای تعطیل
- ✅ اضافه‌کاری (Overtime)
- ✅ کسر کار (جریمه)
- ✅ تنظیم دستی برای موارد خاص

### 📊 گزارش‌ها و آمار
- ✅ گزارش حضور و غیبت
- ✅ گزارش کارکرد ماهانه
- ✅ گزارش اضافه کار و کسر کار
- ✅ گزارش مرخصی‌های مصرف‌شده
- ✅ آمار پرسنل به تفکیک شعبه

### 🔐 امنیت و کنترل دسترسی
- ✅ احراز هویت کاربر
- ✅ کنترل دسترسی بر اساس نقش (Role-Based)
- ✅ ثبت تغییرات (Audit Log)

### 📱 پلتفرم‌های پشتیبانی‌شده
- ✅ Windows Desktop
- ✅ Android
- ✅ iOS

### 💾 ذخیره‌سازی
- ✅ SQLite (محلی، آفلاین)
- ✅ سرویس Cloud (اختیاری برای همگام‌سازی)

---

## 🏗️ ساختار پروژه

```
employee-management-syste/
│
├── lib/
│   ├── main.dart                      # نقطه شروع اپلیکیشن
│   ├── models/                        # مدل‌های داده
│   │   ├── employee.dart              # مدل پرسنل
│   │   ├── attendance.dart            # مدل حضور
│   │   ├── leave.dart                 # مدل مرخصی
│   │   ├── contract.dart              # مدل قرارداد
│   │   ├── branch.dart                # مدل شعبه
│   │   └── report.dart                # مدل گزارش
│   │
│   ├── database/                      # تنظیمات دیتابیس
│   │   ├── db_helper.dart             # کمک‌دهنده دیتابیس
│   │   └── schema.dart                # نقشه دیتابیس
│   │
│   ├── services/                      # خدمات
│   │   ├── attendance_service.dart    # خدمات حضور
│   │   ├── employee_service.dart      # خدمات پرسنل
│   │   ├── leave_service.dart         # خدمات مرخصی
│   │   ├── report_service.dart        # خدمات گزارش‌ها
│   │   └── auth_service.dart          # خدمات احراز هویت
│   │
│   ├── screens/                       # صفحات
│   │   ├── login_screen.dart          # صفحه ورود
│   │   ├── dashboard_screen.dart      # داشبورد
│   │   ├── employees_screen.dart      # مدیریت پرسنل
│   │   ├── attendance_screen.dart     # ثبت حضور
│   │   ├── leaves_screen.dart         # مدیریت مرخصی
│   │   ├── reports_screen.dart        # گزارش‌ها
│   │   ├── settings_screen.dart       # تنظیمات
│   │   └── details/                   # صفحات جزئیات
│   │
│   ├── widgets/                       # ویجت‌های مشترک
│   │   ├── custom_app_bar.dart        # نوار بالایی سفارشی
│   │   ├── employee_card.dart         # کارت پرسنل
│   │   ├── attendance_card.dart       # کارت حضور
│   │   └── custom_buttons.dart        # دکمه‌های سفارشی
│   │
│   ├── utils/                         # ابزارها و کمک‌دهنده‌ها
│   │   ├── constants.dart             # ثابت‌ها
│   │   ├── colors.dart                # رنگ‌ها
│   │   ├── date_utils.dart            # کمک‌دهنده تاریخ
│   │   ├── validators.dart            # تأیید‌کنندگان
│   │   └── enums.dart                 # Enum ها
│   │
│   └── providers/                     # State Management (GetX/Riverpod)
│       ├── employee_provider.dart
│       ├── attendance_provider.dart
│       ├── auth_provider.dart
│       └── report_provider.dart
│
├── assets/                            # منابع (تصاویر، فونت‌ها)
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── pubspec.yaml                       # وابستگی‌های Flutter
├── pubspec.lock
├── analysis_options.yaml              # تنظیمات تحلیل کد
└── .gitignore
```

---

## 🗄️ ساختار دیتابیس

### جداول اصلی:

#### 1️⃣ **Users** (کاربران)
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  full_name TEXT NOT NULL,
  role TEXT NOT NULL, -- admin, manager, employee
  branch_id INTEGER,
  is_active BOOLEAN DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### 2️⃣ **Employees** (پرسنل)
```sql
CREATE TABLE employees (
  id INTEGER PRIMARY KEY,
  employee_code TEXT UNIQUE NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  national_id TEXT UNIQUE NOT NULL,
  phone TEXT,
  email TEXT,
  gender TEXT, -- male, female
  department TEXT,
  branch_id INTEGER NOT NULL,
  hire_date DATE NOT NULL,
  is_active BOOLEAN DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (branch_id) REFERENCES branches(id)
);
```

#### 3️⃣ **Branches** (شعبه‌ها)
```sql
CREATE TABLE branches (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  location TEXT,
  phone TEXT,
  manager_id INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### 4️⃣ **Contracts** (قرارداد‌های کاری)
```sql
CREATE TABLE contracts (
  id INTEGER PRIMARY KEY,
  employee_id INTEGER NOT NULL,
  work_shift_start TEXT NOT NULL, -- "08:00"
  work_shift_end TEXT NOT NULL,   -- "17:00"
  working_days TEXT NOT NULL,     -- "1,2,3,4,5" (شنبه تا چهارشنبه)
  work_hours_per_day REAL NOT NULL, -- 8.5
  contract_type TEXT, -- full-time, part-time
  start_date DATE NOT NULL,
  end_date DATE,
  is_active BOOLEAN DEFAULT 1,
  FOREIGN KEY (employee_id) REFERENCES employees(id)
);
```

#### 5️⃣ **Attendance** (حضور و غیبت)
```sql
CREATE TABLE attendance (
  id INTEGER PRIMARY KEY,
  employee_id INTEGER NOT NULL,
  attendance_date DATE NOT NULL,
  check_in_time TEXT, -- "08:15"
  check_out_time TEXT, -- "17:30"
  status TEXT NOT NULL, -- present, absent, late, early_leave
  notes TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (employee_id) REFERENCES employees(id)
);
```

#### 6️⃣ **Leaves** (مرخصی)
```sql
CREATE TABLE leaves (
  id INTEGER PRIMARY KEY,
  employee_id INTEGER NOT NULL,
  leave_type TEXT NOT NULL, -- annual, sick, unpaid, maternity
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  days_count INTEGER NOT NULL,
  reason TEXT,
  status TEXT DEFAULT 'pending', -- pending, approved, rejected
  approved_by INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (employee_id) REFERENCES employees(id),
  FOREIGN KEY (approved_by) REFERENCES users(id)
);
```

#### 7️⃣ **Holidays** (روزهای تعطیل)
```sql
CREATE TABLE holidays (
  id INTEGER PRIMARY KEY,
  holiday_date DATE NOT NULL,
  holiday_name TEXT NOT NULL,
  holiday_type TEXT, -- national, friday, optional
  is_applicable_to_all BOOLEAN DEFAULT 1,
  branch_id INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### 8️⃣ **WorkLogs** (گزارش کارکرد)
```sql
CREATE TABLE work_logs (
  id INTEGER PRIMARY KEY,
  employee_id INTEGER NOT NULL,
  log_date DATE NOT NULL,
  worked_hours REAL NOT NULL,
  overtime_hours REAL DEFAULT 0,
  deduction_hours REAL DEFAULT 0, -- کسر کار
  work_type TEXT, -- normal, holiday, sick_leave
  notes TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (employee_id) REFERENCES employees(id)
);
```

#### 9️⃣ **AuditLog** (ثبت تغییرات)
```sql
CREATE TABLE audit_log (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  action TEXT NOT NULL,
  table_name TEXT,
  record_id INTEGER,
  old_value TEXT,
  new_value TEXT,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

## 🚀 نصب و اجرا

### الزامات:
- Flutter SDK (نسخه 3.0+)
- Dart SDK
- Android Studio / Xcode (برای iOS)
- Visual Studio Code یا Android Studio

### مراحل:
```bash
# 1. Clone کردن پروژه
git clone https://github.com/saeeddvd60-ui/employee-management-syste.git
cd employee-management-syste

# 2. نصب وابستگی‌ها
flutter pub get

# 3. اجرا روی دستگاه
flutter run

# 4. یا Build کردن
flutter build windows    # Windows
flutter build apk        # Android
flutter build ios        # iOS
```

---

## 📱 نحوه استفاده

### 1. ورود سیستم
- نام کاربری و رمز عبور
- سه سطح دسترسی: مدیر، سرپرست، پرسنل عادی

### 2. داشبورد
- نمایش آمار روزی (حاضران، غایبان، در حال کار)
- دکمه‌های سریع دسترسی

### 3. مدیریت پرسنل
- افزودن/ویرایش/حذف پرسنل
- تعریف قرارداد کاری

### 4. ثبت حضور
- ثبت خودکار با یک کلیک
- ثبت دستی برای موارد خاص

### 5. مدیریت مرخصی
- درخواست مرخصی
- تأیید/رد توسط مدیر

### 6. گزارش‌ها
- گزارش‌های تفصیلی به صورت PDF/Excel
- فیلتر بر اساس شعبه، تاریخ، پرسنل

---

## 🛠️ فناوری‌های استفاده‌شده

- **Frontend:** Flutter
- **Database:** SQLite (Local), Firebase (Optional)
- **State Management:** GetX / Riverpod
- **PDF:** pdf package
- **Charts:** fl_chart
- **Date Picker:** intl / table_calendar

---

## 📄 لایسنس

MIT License - آزاد برای استفاده تجاری و غیرتجاری

---

## 📧 تماس و پشتیبانی

**GitHub:** [saeeddvd60-ui](https://github.com/saeeddvd60-ui)

---

**نسخه:** 1.0.0 | **آخرین به‌روزرسانی:** 2026-07-05