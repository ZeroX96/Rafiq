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