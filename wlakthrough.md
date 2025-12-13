Rafiq App Walkthrough
Overview
Rafiq is a strictly offline Flutter application designed to help Muslims track prayers, manage Qada (missed prayers), read Quran, and perform Azkar. The app prioritizes privacy and works entirely without an internet connection (except for optional audio downloads).

Features Implemented
1. Offline Architecture
Local Database: Uses Drift (SQLite) to store all data locally.
No Backend: Zero dependency on external servers for core logic.
Privacy: Data stays on the device.
2. Daily Prayer Tracking
Location: Users select cities from a bundled 
cities.json
 file.
Calculations: Uses adhan package to calculate prayer times locally based on selected city coordinates.
Notifications: Uses flutter_local_notifications to schedule reminders.
3. Qada (Debt) Management
Calculator: Estimates missed prayers based on years missed (using Lunar year logic: 354 days).
Auto-Increment: Logic to automatically add missed daily prayers to the debt.
Tracking: Dedicated table in SQLite to track total debt vs. paid count.
4. Quran & Hadith
Data: Bundled 
quran.json
 with Uthmani script and Sahih International translation.
Audio: On-demand download capability using http and path_provider.
5. Azkar
Counter: Digital tally counter with Haptic Feedback and Sound.
Customization: Database schema supports custom Azkar and rewards.
6. Security & Export
Lock: Biometric/PIN authentication using local_auth.
Backup: Export database to JSON using share_plus.
Verification Results
Build: flutter build apk --debug PASSED.
Release Build: flutter build apk --release PASSED.
APK Path: 
build/app/outputs/flutter-apk/app-release.apk
Web Build: flutter build web PASSED.
Path: build/web
Note: Charts disabled for web compatibility. Database uses drift_web.
Build Fixes Applied:
Downgraded flutter_secure_storage to 9.2.2.
Downgraded share_plus to 10.0.0.
Upgraded Kotlin to 1.9.24.
Enabled coreLibraryDesugaring.
Refactored AppDatabase to support Web (conditional imports).
Code Implementation:
Onboarding: Implemented city selection.
UI: All tabs (Prayer, Qada, Quran, Azkar, Overview) implemented with functional logic.
Dependencies: All conflicts resolved.
Next Steps
Install: Transfer app-release.apk to your phone and install.
UI Polish: Replace placeholder screens with detailed UI implementation.