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