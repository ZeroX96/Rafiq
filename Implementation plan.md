Rafiq App Implementation Plan
Goal Description
Develop "Rafiq", a comprehensive strictly offline Flutter application for Muslim prayer tracking, missed prayer (Qada) management, Quran/Hadith reading, and Azkar. The app prioritizes privacy, keeping all data locally on the device. It includes features for tracking personal progress and optionally monitoring family/friends via local profiles.

User Review Required
IMPORTANT

Offline Constraint vs. Friend Checking: To satisfy "check up on other friends" while remaining "fully offline", I have proposed a Local Multi-Profile System. This allows a user to switch profiles (e.g., Parent checking a Child's profile) on the same device. Please confirm if this matches your intent in the questions below.

NOTE

Qada Skip: The Qada calculator is now optional during onboarding.

Technical Architecture
Tech Stack
Framework: Flutter (Dart)
State Management: Riverpod
Local Database: Drift (SQLite) - Crucial for offline data persistence.
Encryption: SQLCipher (Optional but recommended for privacy).
No Backend: The app will have zero network dependencies for core features.
Project Structure
lib/
├── main.dart
├── core/
│   ├── database/ (Drift with Multi-user schema)
│   └── ...
├── features/
│   ├── daily_prayer/
│   ├── qada_debt/ (Includes Calculator & Skip Logic)
│   ├── quran_hadith/ (Local Assets)
│   ├── azkar/
│   └── overview/ (Includes Multi-profile dashboard)
Proposed Changes
1. Database Schema (Multi-Profile Support)
UsersTable: id, name, is_current_active.
PrayersTable: user_id (FK), date, status...
QadaTable: user_id (FK), prayer_name, debt_count...
SettingsTable: user_id (FK), madhhab, qada_enabled (bool)...
2. Feature: Daily Prayer Tracking (Tab 1)
Offline Logic: Prayer times calculated locally using adhankit or prayer_times package based on GPS (or manual location entry if GPS is denied).
Data: All logs stored in local SQLite DB.
3. Feature: Debt/Qada Tracking (Tab 2)
Skip Logic: Onboarding will have a "Skip Qada Calculator" button.
Settings: Toggle "Show Qada Tracker" in settings to hide/unhide the tab later.
Calculator: Standard inputs (Age, Puberty, etc.) -> Estimate -> Save to DB.
4. Feature: Quran & Hadith (Tab 3)
Assets: Full Quran text and selected Hadiths bundled with the app (no download needed).
Audio: Constraint Check - Offline audio requires bundling large files (hundreds of MBs). Proposal: Bundle only text initially. Audio would require optional download (which violates strict offline if not pre-bundled) or we omit audio for the MVP. Plan: Text only for MVP.
5. Feature: Azkar (Tab 4)
Gamification: "Trees in Heaven" logic.
Customization: User can add custom Azkar locally.
6. Feature: User Overview & Friends (Tab 5)
Personal Stats: Streak, On-time %, Trees planted.
Friend/Family Check-up (Offline):
Profile Switcher: "Switch User" button in the app bar.
Summary View: A "Family Dashboard" showing a read-only list of other local profiles' progress (e.g., "Ali: 5/5 Prayers", "Sarah: 3/5 Prayers").
Verification Plan
Automated Tests
Unit: Test Qada skip logic (ensure debt = 0 if skipped).
Integration: Test creating multiple users and ensuring data isolation (User A's prayers don't show on User B's graph).
Manual Verification
Offline Mode: Enable Airplane mode -> Install App -> Run through full flow.
Privacy: Verify no network requests are made (using network inspector).
Multi-user: Create "Dad" and "Son" profiles. Log prayers for "Son". Switch to "Dad" and verify "Son's" progress is visible in the overview (if designed) or by switching.

