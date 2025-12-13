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