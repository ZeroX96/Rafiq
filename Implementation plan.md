Rafiq App Implementation Plan
Goal Description
Develop "Rafiq", a strictly offline Flutter application for Muslim prayer tracking, missed prayer (Qada) management, Quran/Hadith reading, and Azkar. The app prioritizes privacy with local storage, PIN security, and data export capabilities.

Technical Architecture
Tech Stack
Framework: Flutter (Dart)
State Management: Riverpod
Local Database: Drift (SQLite)
Security: local_auth (Biometrics/PIN), flutter_secure_storage (for keys).
Navigation: GoRouter
Charts: fl_chart
Export: csv or json_serializable + share_plus.
Project Structure
lib/
├── main.dart
├── core/
│   ├── database/ (Drift)
│   ├── security/ (Auth Logic)
│   └── services/ (Notifications, Export)
├── features/
│   ├── daily_prayer/
│   ├── qada_debt/
│   ├── quran_hadith/
│   ├── azkar/
│   └── overview/
Proposed Changes
1. Project Setup & Security
Dependencies: Add local_auth, share_plus, path_provider, permission_handler.
Security: Implement PIN/Biometric lock screen on app startup.
Data Export: Create a service to dump DB tables to JSON/CSV and share via system sheet.
2. Feature: Daily Prayer Tracking (Tab 1)
Location: User selects city from a bundled local database (no GPS).
Logic:
Calculate times locally (configurable method/madhhab).
Statuses: Prayed, Late, Missed, Excused.
Notifications: System local notifications + Pre-notifications (15 min).
Sound: Support custom user-provided Adhan files.
3. Feature: Debt/Qada Tracking (Tab 2)
Logic:
Auto-increment: Background task/check at 11:30 PM to add missed daily prayers to debt.
Calculator: Uses Lunar years (354 days).
Input: Allow specific counts (e.g., "50 Fajr") or time periods.
Skip: Option to skip calculator (Debt = 0), but tab remains visible.
Constraint: No negative debt.
4. Feature: Quran & Hadith (Tab 3)
Content:
Text: Uthmani script, Sahih International translation (Bundled).
Audio: Not bundled. User can download MP3s if needed (handled as external file download).
Hadith: Sahih Bukhari & Muslim (Bundled text).
Features: Auto-bookmarking.
5. Feature: Azkar (Tab 4)
Customization: CRUD for Custom Azkar & Rewards.
Feedback: Haptic/Sound on tap.
Goals: Daily targets.
6. Feature: User Overview (Tab 5)
Stats: Streaks (configurable), Charts.
Privacy: Toggle to "Hide Debt" from dashboard.
Theme: Green/Gold/Blue/White palette.
Verification Plan
Automated Tests
Unit: Test Lunar year calculation (e.g., 1 year = 354 days * 5).
Unit: Test Auto-increment logic.
Widget: Test PIN screen blocks access until authenticated.
Manual Verification
Security: Enable PIN, restart app, verify lock screen.
Export: Export data, inspect JSON/CSV for correctness.
Offline: Verify app works without internet (except optional audio download).




Implementation Plan - Gamification & Enhancements
Goal
Implement gamification for daily prayers, enhance Qada UI, integrate real Quran content, and fix Azkar functionality.

Proposed Changes
1. Dependencies
[MODIFY] 
pubspec.yaml
Add fl_chart (re-add for mobile).
Add quran (for Quran content).
Add flutter_local_notifications (for Azkar reminders).
Add flutter_islamic_icons (for Muslim icons).
2. Daily Prayer Gamification
[MODIFY] 
daily_prayer_screen.dart
Add "Score" display (0-100%).
Add "Rank" badge (e.g., Beginner, Hafiz, etc.).
Add "Weekly Progress" chart using fl_chart.
3. Qada Tab Enhancements
[MODIFY] 
qada_debt_screen.dart
Redesign tiles: Larger numbers, single "Prayed" button.
Add "Hide Debt" toggle.
Add "Motivational/Warning" text section.
4. Quran Content
[MODIFY] 
quran_hadith_screen.dart
Use quran package to list Surahs and display verses.
5. Azkar Fixes
[MODIFY] 
azkar_screen.dart
Implement persistence for counters.
Fix "+" button logic.
Add reminder scheduling logic.
6. UI Polish
[MODIFY] 
scaffold_with_nav_bar.dart
 (or main.dart)
Replace standard icons with flutter_islamic_icons (or similar assets).
Add a "Daily Verse" or relevant Quran text widget to the top/bottom of the Scaffold.
Verification Plan
Manual Testing:
Verify Score/Rank updates.
Verify Chart renders on mobile.
Verify Qada UI changes and "Hide" toggle.
Verify Quran content loads.
Verify Azkar counters persist and reminders trigger.
Verify new Icons and Quran text presence.

Implementation Plan - Gamification & Enhancements
Goal
Implement gamification for daily prayers, enhance Qada UI, integrate real Quran content, and fix Azkar functionality.

Proposed Changes
1. Dependencies
[MODIFY] 
pubspec.yaml
Add home_widget (for Android widget).
Add google_sign_in (optional, or just regex for Gmail).
2. Onboarding Overhaul
[MODIFY] 
onboarding_screen.dart
Validation: Enforce alphabet-only names and valid Gmail regex.
Navigation: Fix WillPopScope for back button and onSubmitted for Enter key.
Content: Add Quran/Hadith/Quotes to each step.
Logic: Add Menstruation Duration step and allow manual debt correction.
3. Daily Prayer Gamification
[MODIFY] 
daily_prayer_screen.dart
Gamification: Fix score calculation (dynamic based on checked items).
Charts: Fix fl_chart implementation.
Content: Add Shafaa and Witr prayers.
4. Qada Tab Enhancements
[MODIFY] 
qada_debt_screen.dart
UI: Convert prayer rows into large tappable buttons.
Logic: Keep "+" button for manual adjustments.
5. Quran Content
[MODIFY] 
quran_hadith_screen.dart
Logic: Fix data loading (ensure quran package works or fetch from API).
Tracking: Add "Mark as Read" feature and track total verses.
6. Azkar Fixes
[MODIFY] 
azkar_screen.dart
Logic: Add lifetime counter (persisted).
Reminders: Implement showTimePicker for specific reminders.
7. Overview Tab Revamp
[MODIFY] 
overview_screen.dart
UI: Revamp to show real data (Prayers, Quran, Azkar, Debt).
Charts: Add 3 types of charts (e.g., Weekly Prayers, Debt Progress, Quran Reading).
Settings: Add button to access settings.
8. Home Screen Widget
New Feature: Implement home_widget to show summary on Android home screen.
Verification Plan
Manual Testing:
Verify Score/Rank updates.
Verify Chart renders on mobile.
Verify Qada UI changes and "Hide" toggle.
Verify Quran content loads.
Verify Azkar counters persist and reminders trigger.
Verify new Icons and Quran text presence.


Implementation Plan - Gamification & Enhancements
Goal
Implement gamification for daily prayers, enhance Qada UI, integrate real Quran content, and fix Azkar functionality.

Proposed Changes
1. Dependencies
[MODIFY] 
pubspec.yaml
Add home_widget (for Android widget).
Add google_sign_in (optional, or just regex for Gmail).
2. Onboarding Overhaul
[MODIFY] 
onboarding_screen.dart
Validation: Enforce alphabet-only names and valid Gmail regex.
Navigation: Fix WillPopScope for back button and onSubmitted for Enter key.
Content: Add Quran/Hadith/Quotes to each step.
Logic: Add Menstruation Duration step and allow manual debt correction.
3. Daily Prayer Gamification
[MODIFY] 
daily_prayer_screen.dart
Gamification: Fix score calculation (dynamic based on checked items).
Charts: Fix fl_chart implementation.
Content: Add Shafaa and Witr prayers.
4. Qada Tab Enhancements
[MODIFY] 
qada_debt_screen.dart
UI: Convert prayer rows into large tappable buttons.
Logic: Keep "+" button for manual adjustments.
5. Quran Content
[MODIFY] 
quran_hadith_screen.dart
Logic: Fix data loading (ensure quran package works or fetch from API).
Tracking: Add "Mark as Read" feature and track total verses.
6. Azkar Fixes
[MODIFY] 
azkar_screen.dart
Logic: Add lifetime counter (persisted).
Reminders: Implement showTimePicker for specific reminders.
7. Overview Tab Revamp
[MODIFY] 
overview_screen.dart
UI: Revamp to show real data (Prayers, Quran, Azkar, Debt).
Charts: Add 3 types of charts (e.g., Weekly Prayers, Debt Progress, Quran Reading).
Settings: Add button to access settings.
8. Home Screen Widget
New Feature: Implement home_widget to show summary on Android home screen.
Verification Plan
Manual Testing:
Verify Score/Rank updates.
Verify Chart renders on mobile.
Verify Qada UI changes and "Hide" toggle.
Verify Quran content loads.
Verify Azkar counters persist and reminders trigger.
Verify new Icons and Quran text presence.

Implementation Plan - Data Synchronization & Missed Prayer Logic
Goal
Ensure all screens share consistent data, Overview reflects real-time stats, and missed prayers are automatically added to Qada debt when the day ends.

User Review Required
IMPORTANT

This plan introduces automatic Qada debt addition for missed Fard prayers. Only the 5 obligatory prayers (Fajr, Dhuhr, Asr, Maghrib, Isha) will be added to debt if missed. Sunnah prayers (Sunrise, Shafaa, Witr) will NOT affect Qada debt.

Proposed Changes
1. Core Service - Missed Prayer Checker
[NEW] 
missed_prayer_service.dart
Create a service to check for missed prayers from previous days
On app startup, check if any Fard prayers from yesterday were not marked as done
If missed, increment the corresponding Qada debt counter
Store last_checked_date to avoid duplicate additions
2. Main App Integration
[MODIFY] 
main.dart
Call MissedPrayerService.checkAndAddMissedPrayers() during app startup
This runs after 
NotificationService
 initialization
3. Overview Screen - Real-time Refresh
[MODIFY] 
overview_screen.dart
Add 
didChangeDependencies()
 or use WidgetsBindingObserver to refresh data when screen is revisited
Add Sunrise to prayer count (8 prayers total) for consistency
4. Quran Screen - Ensure Verse Count Saves
[MODIFY] 
quran_hadith_screen.dart
Verify quran_total_verses_read is incremented when marking verses as read
Add method to update total in SurahDetailScreen if missing
Data Key Mapping (Reference)
Screen	SharedPreferences Key	Description
Daily Prayer	prayer_{date}_{prayer}	Boolean for backward compat
Daily Prayer	prayer_status_{date}_{prayer}	Status string (Fard, Jamaa, Late, Missed, None)
Qada Debt	qada_debt_{prayer}	Integer debt count per prayer
Azkar	azkar_lifetime_total	Lifetime Azkar count
Quran	quran_total_verses_read	Total verses marked as read
Overview	Reads all above keys	Aggregated view
Missed Check	last_missed_prayer_check	Date of last check
Verification Plan
Automated Tests
Run flutter build apk --release to verify no compilation errors
Manual Verification
Mark a prayer as missed, wait for next day startup, verify Qada debt incremented
Navigate between tabs and verify Overview updates
Check Qada debt matches between Qada screen and Overview
Verify Azkar lifetime count updates in Overview after incrementing in Azkar screen
Verify Quran verses read updates in Overview after marking verses in Quran screen



Prayer Notifications System - Implementation Plan
Goal
Implement a comprehensive Prayer Notifications System with auto-scheduling, interactive actions, pre-prayer reminders, and post-prayer checks.

Current State Analysis
✅ Already Implemented
NotificationService exists with:

schedulePrayerNotification()
 method
"Prayed" and "Remind in 30m" action buttons
Timezone support via tz library
Permission handling
"Remind Later" action handling in 
main.dart
:

Reschedules notification for 30 minutes
Prayer times calculation in 
DailyPrayerScreen
:

Uses Adhan library
Has _prayerTimes object with Fajr, Dhuhr, Asr, Maghrib, Isha
❌ Not Yet Implemented
Auto-scheduling notifications at prayer times
"Prayed" action handling (mark prayer as done)
Pre-prayer reminders
Post-prayer check notifications
Settings for notification preferences
Midnight rescheduling
Proposed Changes
1. New File: PrayerNotificationScheduler Service
[NEW] 
prayer_notification_scheduler.dart
class PrayerNotificationScheduler {
  // Schedule all prayer notifications for today
  static Future<void> scheduleAllPrayerNotifications();
  
  // Schedule pre-prayer reminder
  static Future<void> schedulePrePrayerReminder(String prayer, DateTime time, int minutesBefore);
  
  // Schedule post-prayer check
  static Future<void> schedulePostPrayerCheck(String prayer, DateTime time);
  
  // Cancel all and reschedule (for midnight reset)
  static Future<void> rescheduleAll();
}
2. Modify: NotificationService
[MODIFY] 
notification_service.dart
Add new methods:

schedulePrePrayerNotification() - different channel/sound
schedulePostPrayerNotification() - reminder style
Add unique notification IDs per type
3. Modify: main.dart
[MODIFY] 
main.dart
Handle "Prayed" action:

if (response.actionId == 'prayed') {
  // Mark prayer as Fard in SharedPreferences
}
Schedule notifications on app startup.

4. New Settings: Notification Preferences
[MODIFY] 
settings_screen.dart
Add settings section:

Enable/Disable prayer notifications
Pre-prayer reminder time (dropdown: Off/5/10/15/30 min)
Post-prayer check (toggle)
5. Midnight Rescheduling
Use Android AlarmManager or WorkManager to trigger rescheduling at midnight.

Notification ID Scheme
Notification Type	ID Formula	Example
Prayer Time	prayer.hashCode	Fajr → 123456
Pre-Prayer Reminder	prayer.hashCode + 1000	Fajr → 124456
Post-Prayer Check	prayer.hashCode + 2000	Fajr → 125456
Remind Later	timestamp.milliseconds	1702920000000
User Review Required
IMPORTANT

Please answer the following questions before implementation:

Questions for User:
Pre-Prayer Reminder Default: What should be the default pre-prayer reminder time?

Options: Off / 5 min / 10 min / 15 min / 30 min
Post-Prayer Check Delay: How long after prayer time should the "Did you pray?" notification appear?

Suggested: 30 minutes
Other: _____ minutes
Azan Sound: Should the notification play the Azan sound or a regular notification sound?

Option A: Azan sound
Option B: Regular notification sound
Option C: User choice in settings
Which Prayers to Notify: Should all 5 Fard prayers get notifications, or should user configure per-prayer?

Option A: All 5 Fard prayers (no configuration)
Option B: Per-prayer on/off toggle in settings
Sunnah Prayer Notifications: Should Sunnah prayers (Sunrise, Shafaa, Witr) also get notifications?

Yes / No
Midnight Rescheduling: Is it acceptable to use Android WorkManager for background scheduling, or prefer simpler approach?

Verification Plan
Automated Tests
Run flutter build apk --release
Manual Verification
Enable notifications, wait for next prayer time
Verify notification appears at correct time
Test "Prayed" action marks prayer as done
Test "Remind Later" reschedules correctly
Verify pre-prayer reminder appears X minutes before
Verify post-prayer check appears 30 minutes after
Test settings toggles work correctly
Awaiting user answers before proceeding with implementation.