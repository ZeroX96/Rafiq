# Rafiq - Implemented Features

> **Version**: 1.0.0  
> **Last Updated**: December 18, 2025  
> **Status**: Production Ready

---

## 📋 Table of Contents

1. [Onboarding & User Profile](#1-onboarding--user-profile)
2. [Daily Prayer Screen](#2-daily-prayer-screen-home-tab)
3. [Qada Debt Screen](#3-qada-debt-screen-qada-tab)
4. [Quran & Hadith Screen](#4-quran--hadith-screen-quran-tab)
5. [Azkar Screen](#5-azkar-screen-azkar-tab)
6. [Overview Screen](#6-overview-screen-overview-tab)
7. [Settings Screen](#7-settings-screen)
8. [Core Services & Backend](#8-core-services--backend)
9. [Navigation & User Experience](#9-navigation--user-experience)
10. [Technical Architecture](#10-technical-architecture)

---

## 1. Onboarding & User Profile

### 1.1 Multi-Step Onboarding Wizard
The onboarding process consists of 6 comprehensive steps designed to personalize the user experience:

| Step | Screen | Purpose |
|------|--------|---------|
| 1 | Welcome & Name | Collect user's name and email |
| 2 | Personal Details | Gender and Madhab selection |
| 3 | Age & Puberty | Date of birth and puberty age |
| 4 | Qada Options | Debt calculation method selection |
| 5 | Location | City selection for prayer times |
| 6 | Summary | Review and confirm all settings |

### 1.2 User Profile Fields

#### Basic Information
- **Name**: Text input with alphabetic validation
- **Email**: Gmail address validation (`*@gmail.com`)
- **Gender**: Dropdown with 4 options
  - 👦 Boy (for minors)
  - 👨 Man (for adults)
  - 👧 Girl (for minors)
  - 👩 Woman (for adults)

#### Islamic Preferences
- **Madhab Selection**: 
  - Hanafi
  - Shafi'i
  - Maliki
  - Hanbali

#### Age & Puberty
- **Date of Birth**: Date picker (1950 - Present)
- **Puberty Age**: Slider (9-18 years)
  - Used for Qada debt calculation
  - Default: 13 years

#### Female-Specific Settings
- **Menstruation Duration**: Slider (3-10 days)
  - Only shown for Girl/Woman gender
  - Used to deduct non-prayer days from Qada calculation
  - Default: 7 days

### 1.3 Qada Calculation Options

#### Option 1: Calculate from Puberty
```
Total Debt = (Current Age - Puberty Age) × 365 days × 5 prayers
            - (Menstruation Days × 5 prayers per month)  [for females]
```

#### Option 2: Enter Duration Manually
Users can specify exact duration of missed prayers:
- **Years Missed**: 0-99 years
- **Months Missed**: 0-11 months
- **Weeks Missed**: 0-4 weeks
- **Days Missed**: 0-30 days

#### Option 3: Manual Entry Per Prayer
Direct input for each prayer type:
- Fajr: _____ prayers
- Dhuhr: _____ prayers
- Asr: _____ prayers
- Maghrib: _____ prayers
- Isha: _____ prayers
- Witr: _____ prayers (if Sunnah tracking enabled)

### 1.4 Sunnah Tracking Preference
- **Toggle Switch**: "Track Sunnah Prayers"
- **Description**: Include Sunrise, Shafaa, and Witr in Qada debt
- **Default**: Disabled (Fard only)

### 1.5 Location Selection
- Pre-loaded cities database from JSON asset
- Displays: City name, Country
- Stores: Latitude, Longitude, City name
- Used for accurate prayer time calculation

### 1.6 PIN Security Setup
- Optional 4-digit PIN
- Can be set during onboarding
- Can be changed/removed in Settings

### 1.7 Inspirational Quotes
Each onboarding step displays relevant Islamic quotes:

| Step | Quote | Source |
|------|-------|--------|
| 1 | "The first thing for which a person will be brought to account..." | Sunan an-Nasa'i 465 |
| 2 | "Read the Quran, for it will come as an intercessor..." | Sahih Muslim 804 |
| 3 | "The Pen has been lifted from three..." | Sunan Abi Dawud 4403 |
| 4 | "Allah does not burden a soul beyond that it can bear." | Quran 2:286 |

---

## 2. Daily Prayer Screen (Home Tab)

### 2.1 Prayer Times Display
- **Location Header**: Shows current city name
- **Prayer Time Calculation**: Uses Adhan library
- **Calculation Method**: Muslim World League
- **Madhab**: Hanafi (affects Asr calculation)

### 2.2 Prayer Categories

#### Fard Prayers (Obligatory) - 5 prayers
| Prayer | Time Source | Affects Qada |
|--------|-------------|--------------|
| Fajr | Adhan library | ✅ Yes |
| Dhuhr | Adhan library | ✅ Yes |
| Asr | Adhan library | ✅ Yes |
| Maghrib | Adhan library | ✅ Yes |
| Isha | Adhan library | ✅ Yes |

#### Sunnah Prayers (Optional) - 3 prayers
| Prayer | Time Source | Affects Qada |
|--------|-------------|--------------|
| Sunrise | Adhan library | Only if enabled |
| Shafaa | Isha + 30 min | Only if enabled |
| Witr | Isha + 45 min | Only if enabled |

### 2.3 Prayer Status Options
Each prayer can be marked with one of 5 statuses:

| Status | Color | Points | Description |
|--------|-------|--------|-------------|
| None | Gray | 0 | Not yet prayed |
| Fard | Green | 10 | Prayed individually |
| Jamaa | Gold | 15 | Prayed in congregation |
| Late | Orange | 5 | Prayed but late |
| Missed | Red | 0 | Intentionally missed |

### 2.4 Gamification System

#### Daily Score Calculation
```dart
int score = 0;
for (prayer in prayers) {
  if (status == 'Jamaa') score += 15;
  else if (status == 'Fard') score += 10;
  else if (status == 'Late') score += 5;
}
// Maximum possible: 75 points (5 Fard × 15 Jamaa)
```

#### Rank System
| Rank | Score Threshold | Icon |
|------|-----------------|------|
| Muslim | 0-20 | 🌙 |
| Mu'min | 21-40 | ⭐ |
| Muttaqi | 41-55 | 🌟 |
| Siddiq | 56-70 | ✨ |
| Shahid | 71-75 | 👑 |

### 2.5 Weekly Progress Chart
- **Type**: Bar chart (fl_chart library)
- **Data**: Last 7 days prayer completion
- **Max Value**: 7 prayers per day
- **Color**: Green if 7/7, Primary otherwise
- **Labels**: M, T, W, T, F, S, S

### 2.6 Daily Quran Verse
- **Algorithm**: Based on day of year
- **Surah Selection**: `dayOfYear % 114 + 1`
- **Verse Selection**: `dayOfYear % verseCount + 1`
- **Deep Link**: Tappable to navigate to full surah

---

## 3. Qada Debt Screen (Qada Tab)

### 3.1 Grouped Prayer Display

#### Fard Prayers Section (Always Shown)
- Header: "Fard Prayers (Obligatory)"
- Prayers: Fajr, Dhuhr, Asr, Maghrib, Isha
- Icon: Mosque icon (primary color)

#### Sunnah Prayers Section (Conditional)
- Header: "Sunnah Prayers (Optional)"
- Prayers: Sunrise, Shafaa, Witr
- Icon: Star icon (secondary color)
- **Visibility**: Only shown if `track_sunnah_debt == true`

### 3.2 Debt Tile Interactions

#### Decrement (Tap Tile)
- Haptic feedback on tap
- Decrements debt by 1
- Records timestamp for analytics
- Saves to SharedPreferences

#### Increment (Plus Button)
- For corrections/additions
- Haptic feedback
- No timestamp recorded

### 3.3 Progress Tracking

#### Pie Chart Display
```dart
_paidPercentage = ((_totalOriginal - _totalDebt) / _totalOriginal * 100)
                  .clamp(0, 100);
```

#### Statistics Shown
- Paid percentage (green section)
- Remaining percentage (gray section)
- Total remaining prayers count

### 3.4 Privacy Features
- **Hide Debt Toggle**: Shows "---" instead of numbers
- **Persists**: Setting saved to preferences

### 3.5 Rotating Quotes
4 motivational quotes about prayer debt:
1. "The first thing for which a person will be brought to account..."
2. "Between a man and shirk and kufr is neglecting the prayer."
3. "Whoever misses a prayer, let him make it up when he remembers."
4. "The covenant between us and them is the prayer..."

---

## 4. Quran & Hadith Screen (Quran Tab)

### 4.1 Tab Structure
- **Tab 1**: Quran (green icon)
- **Tab 2**: Hadith (amber icon)

### 4.2 Quran Features

#### Surah List
- All 114 Surahs displayed
- Arabic name + English transliteration
- Verse count
- Revelation type (Meccan/Medinan)

#### Surah Detail Screen
- Scrollable verse list
- Arabic text for each verse
- Verse numbers
- Tappable verses to toggle read status
- Progress tracking per surah

#### Deep Linking
- Route: `/quran-hadith/surah/:surahNumber?verse=X`
- Supports direct navigation to specific verse

#### Read Tracking
- SharedPreferences key: `quran_verse_read_{surah}_{verse}`
- Total counter: `quran_total_verses_read`

### 4.3 Hadith Features

#### Collections
- **Built-in**: Forty Hadith an-Nawawi (13 hadith)
- **API Integration**: sunnah.com API

#### Hadith Display
- Hadith number
- Title
- Arabic text (when available)
- English translation
- Source reference

#### API Search
- Search by keyword
- Results from sunnah.com
- Pagination support

---

## 5. Azkar Screen (Azkar Tab)

### 5.1 Default Azkar Collection

| Azkar | Default Target |
|-------|----------------|
| Subhan Allah | 33 |
| Alhamdulillah | 33 |
| Allahu Akbar | 34 |
| Astaghfirullah | 100 |
| La ilaha illallah | 100 |

### 5.2 Counter Widget
- Large tappable area
- Circular progress indicator
- Current count / Target display
- Haptic feedback on tap
- Auto-reset at target (optional)

### 5.3 Lifetime Counter
- Tracks all-time Azkar count
- SharedPreferences key: `azkar_lifetime_total`
- Displayed in Overview screen

### 5.4 Reminder System

#### Time Picker
- 24-hour format
- Add multiple reminders

#### Notification Scheduling
- Uses flutter_local_notifications
- Recurring daily notifications
- Unique ID per reminder

#### Reminder Management
- View all scheduled reminders
- Delete individual reminders
- Persisted to SharedPreferences

---

## 6. Overview Screen (Overview Tab)

### 6.1 Summary Cards

| Stat | Source | Icon |
|------|--------|------|
| Today's Prayers | Daily Prayer Screen | Mosque |
| Verses Read | Quran Screen | Book |
| Lifetime Azkar | Azkar Screen | Tasbih |
| Qada Debt | Qada Debt Screen | Warning |

### 6.2 Weekly Prayer Chart
- Same as Daily Prayer screen chart
- 7-day bar chart
- Real-time data

### 6.3 Monthly Calendar
- Uses table_calendar package
- Shows current month
- Visual prayer completion indicators

### 6.4 Challenges System

| Period | Challenge | Progress Source |
|--------|-----------|-----------------|
| Daily | Pray all 5 prayers | `_todayPrayersDone / 5` |
| Weekly | Read Surah Kahf | Manual completion |
| Monthly | Complete Quran | `_totalVersesRead / 6236` |
| 3-Month | Learn 10 Hadith | Manual (20% shown) |
| 6-Month | Fast 6 days of Shawwal | Manual |
| 9-Month | Memorize Juz Amma | Manual (10% shown) |
| 12-Month | Perform Umrah | Manual |

#### Challenge Completion
- Tap to toggle complete
- Haptic feedback
- SnackBar confirmation
- Progress bar updates

### 6.5 Auto-Refresh
- `didChangeDependencies()` triggers reload
- Ensures fresh data on each visit

---

## 7. Settings Screen

### 7.1 Profile Section
- Edit Name (with validation)
- Change Gender
- Change Madhab
- View/Change Location

### 7.2 Security Section
- **Set PIN**: Create 4-digit PIN
- **Change PIN**: Update existing PIN
- **Remove PIN**: Disable app lock

### 7.3 Appearance Section
- Theme: Follows system (Light/Dark)
- Future: Custom color schemes

### 7.4 Data Management

| Action | Effect |
|--------|--------|
| Export Data | JSON export to file |
| Reset Onboarding | Clear profile, keep prayers |
| Clear All Data | Factory reset |

---

## 8. Core Services & Backend

### 8.1 NotificationService
**File**: `lib/core/services/notification_service.dart`

```dart
class NotificationService {
  // Singleton pattern
  static final _instance = NotificationService._internal();
  
  // Methods
  Future<void> initialize(callback);
  Future<void> requestPermissions();
  Future<void> schedulePrayerNotification({id, title, body, scheduledTime, payload});
  Future<void> cancelNotification(id);
  Future<void> cancelAll();
}
```

#### Notification Actions
- **prayed**: Mark prayer as done
- **remind_later**: Reschedule for 30 minutes

### 8.2 MissedPrayerService
**File**: `lib/core/services/missed_prayer_service.dart`

```dart
class MissedPrayerService {
  static const List<String> fardPrayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
  static const List<String> sunnahPrayers = ['Sunrise', 'Shafaa', 'Witr'];
  
  static Future<int> checkAndAddMissedPrayers();
  static Future<void> resetLastCheckedDate();
}
```

#### Logic Flow
1. Check `last_missed_prayer_check` date
2. If not today, check yesterday's prayers
3. For each unmarked Fard prayer, increment Qada debt
4. If Sunnah tracking enabled, include Sunnah prayers
5. Update `last_missed_prayer_check` to today

### 8.3 SettingsService (Riverpod)
**File**: `lib/core/services/settings_service.dart`

```dart
class SettingsService extends StateNotifier<SettingsState> {
  Future<void> saveProfile({name, gender, madhab, pubertyAge, dob});
  Future<Map?> getProfile();
  Future<void> saveLocation(lat, lng, name);
  Future<Map?> getLocation();
  Future<void> setOnboardingCompleted(bool);
}
```

### 8.4 PinService
**File**: `lib/core/services/pin_service.dart`

```dart
class PinService {
  static bool isVerified = false;
  
  static Future<void> setPin(String pin);
  static Future<bool> verifyPin(String pin);
  static Future<void> removePin();
  static Future<bool> hasPin();
}
```

### 8.5 QadaCalculator
**File**: `lib/features/qada_debt/domain/qada_calculator.dart`

```dart
class QadaCalculator {
  static const int daysInLunarYear = 354;
  static const int prayersPerDay = 5;
  
  Map<String, int> calculateDebtFromProfile({dob, pubertyAge, gender, hasMenstruation, menstruationDuration});
  Map<String, int> calculateDebtDetailed({years, months, weeks, days, gender, hasMenstruation, menstruationDuration});
}
```

---

## 9. Navigation & User Experience

### 9.1 Bottom Navigation Bar
- 5 destinations with icons
- Swipeable PageView
- Synced with GoRouter

| Tab | Icon | Color |
|-----|------|-------|
| Home | Home | Blue |
| Qada | History | Orange |
| Quran | Book | Green |
| Azkar | Flower | Purple |
| Overview | Person | Teal |

### 9.2 Routing (GoRouter)

```dart
routes: [
  '/onboarding'
  '/settings'
  '/pin'
  ShellRoute('/daily-prayer', '/qada-debt', '/quran-hadith', '/azkar', '/overview')
  '/quran-hadith/surah/:surahNumber?verse=X'
]
```

### 9.3 Double-Back-to-Exit
- Custom wrapper widget
- Shows SnackBar warning
- 2-second window to confirm exit

### 9.4 App Lifecycle Observer
- Listens for `AppLifecycleState.resumed`
- Triggers missed prayer check on resume

---

## 10. Technical Architecture

### 10.1 State Management
- **Riverpod**: For global services (Settings)
- **setState**: For local screen state
- **SharedPreferences**: For persistence

### 10.2 Dependencies

| Package | Purpose |
|---------|---------|
| flutter_riverpod | State management |
| go_router | Navigation |
| shared_preferences | Local storage |
| adhan | Prayer times |
| quran | Quran data |
| fl_chart | Charts |
| table_calendar | Calendar widget |
| flutter_local_notifications | Notifications |
| timezone | Time zone handling |
| intl | Date formatting |
| http | API calls |
| flutter_islamic_icons | Islamic icons |

### 10.3 File Structure

```
lib/
├── main.dart
├── core/
│   ├── services/
│   │   ├── notification_service.dart
│   │   ├── missed_prayer_service.dart
│   │   ├── settings_service.dart
│   │   └── pin_service.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       └── double_back_to_exit.dart
└── features/
    ├── daily_prayer/
    │   └── presentation/
    │       └── daily_prayer_screen.dart
    ├── qada_debt/
    │   ├── domain/
    │   │   └── qada_calculator.dart
    │   └── presentation/
    │       └── qada_debt_screen.dart
    ├── quran_hadith/
    │   ├── data/
    │   │   └── hadith_service.dart
    │   └── presentation/
    │       └── quran_hadith_screen.dart
    ├── azkar/
    │   └── presentation/
    │       ├── azkar_screen.dart
    │       └── azkar_counter_widget.dart
    ├── overview/
    │   └── presentation/
    │       └── overview_screen.dart
    ├── settings/
    │   └── presentation/
    │       └── settings_screen.dart
    ├── onboarding/
    │   └── presentation/
    │       └── onboarding_screen.dart
    └── pin/
        └── presentation/
            └── pin_screen.dart
```

### 10.4 Platform Configuration

#### Android
- Min SDK: 21
- Target SDK: 34
- Permissions: INTERNET, VIBRATE, WAKE_LOCK, SCHEDULE_EXACT_ALARM, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED

#### iOS
- Deployment Target: 12.0
- Notification capabilities configured

---

*End of Implemented Features Documentation*
