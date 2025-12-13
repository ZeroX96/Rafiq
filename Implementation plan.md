Rafiq App Implementation Plan
Goal Description
Develop "Rafiq", a comprehensive offline-first Flutter application for Muslim prayer tracking, missed prayer (Qada) management, Quran/Hadith reading, and Azkar. The app aims to be a supportive companion with gamification elements and detailed progress tracking.

User Review Required
IMPORTANT

Clarification Needed: Please review the 30 questions provided in the chat to clarify specific requirements regarding calculation methods, content sources, and UI preferences.

Technical Architecture
Tech Stack
Framework: Flutter (Dart)
State Management: Riverpod (for robust, testable state management)
Local Database: Drift (SQLite abstraction) or Sqflite. Recommendation: Drift for type safety and reactive streams.
Encryption: SQLCipher (if strict data privacy is required locally as requested).
Navigation: GoRouter
UI Component Library: Material 3 with custom styling for a premium feel.
Charts: fl_chart (for progress visualization).
Localization: easy_localization or Flutter's native l10n.
Project Structure (Feature-First)
lib/
├── main.dart
├── core/
│   ├── theme/
│   ├── utils/
│   └── database/
├── features/
│   ├── daily_prayer/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── qada_debt/
│   ├── quran_hadith/
│   ├── azkar/
│   └── overview/
└── shared/
    └── widgets/
Proposed Changes
1. Project Setup
Initialize Flutter project.
Configure pubspec.yaml with dependencies: flutter_riverpod, drift, sqlite3_flutter_libs, go_router, fl_chart, google_fonts, intl, hijri.
Set up basic theming (Light/Dark mode support).
2. Database Schema (Drift)
PrayersTable: date, prayer_name (Fajr, Dhuhr...), status (prayed, late, missed), timestamp.
QadaTable: prayer_name, total_debt, paid_count.
AzkarTable: zikr_id, count, total_count, reward_description.
SettingsTable: calculation_method, madhhab, notifications_enabled.
3. Feature: Daily Prayer Tracking (Tab 1)
UI: Timeline or Card view for 5 daily prayers.
Logic:
Fetch prayer times (using adhankit or similar algo locally).
Check-in mechanism (On Time, Late, Missed).
Auto-mark missed at day end (background task or check on app open).
4. Feature: Debt/Qada Tracking (Tab 2)
UI: Dashboard showing total debt per prayer.
Calculator: Onboarding wizard to estimate debt based on age/puberty.
Action: "Log Qada" button to decrement debt.
Plan: "Catch-up" suggestions (e.g., +1 Qada with every Fard).
5. Feature: Quran & Hadith (Tab 3)
UI: List of Surahs/Hadith collections.
Content: Load Quran text from local JSON/Asset.
Tracking: Bookmark last read position.
6. Feature: Azkar (Tab 4)
UI: List of Azkar with digital tally counter.
Gamification: "Garden" visualization.
Logic: 1 Zikr = 1 Tree (or specific reward).
Persist total counts.
7. Feature: User Overview (Tab 5)
UI: Summary dashboard.
Stats:
Streak counter.
Weekly/Monthly adherence charts (Bar/Pie charts).
"Trees planted" summary.
Verification Plan
Automated Tests
Unit Tests:
Test Qada calculation logic (e.g., 10 years * 365 days * 5 prayers).
Test Prayer time calculation accuracy.
Widget Tests:
Verify Check-in button updates state.
Verify Navigation between tabs.
Manual Verification
Onboarding: Run through the Qada calculator with different inputs.
Persistence: Close and reopen app to ensure prayer logs and counters are saved.
Offline: Ensure app works 100% without network (simulated airplane mode).