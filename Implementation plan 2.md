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
Verification Plan
Manual Testing:
Verify Score/Rank updates.
Verify Chart renders on mobile.
Verify Qada UI changes and "Hide" toggle.
Verify Quran content loads.
Verify Azkar counters persist and reminders trigger.