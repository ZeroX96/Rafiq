Walkthrough - Phase 4 Enhancements
I have successfully implemented the requested enhancements and bug fixes for Phase 4 of the Rafiq app.

Changes
1. Onboarding & Qada Options
Fixed Empty Screen: Implemented 
_buildQadaOptionsStep
 in 
onboarding_screen.dart
 to replace the empty placeholder.
Qada Calculation Methods: Added options to calculate missed prayers:
From Puberty: Calculates based on age, puberty age, and menstruation (for females).
By Duration: Allows entering the number of years missed.
Manual Entry: Allows specifying exact counts for each prayer.
Menstruation Logic: Updated 
QadaCalculator
 and UI to correctly handle 'Girl' and 'Woman' genders for menstruation deduction.
2. Security (PIN Lock)
PinScreen: Created a new 
PinScreen
 widget for setting up and entering a 4-digit PIN.
PinService: Implemented a service to track PIN verification state.
Integration:
Added PIN check in 
main.dart
 router redirect.
Added "App PIN" option in 
SettingsScreen
 to set/change PIN.
Added "App PIN" tile in 
OnboardingScreen
 summary to allow setting PIN during onboarding.
3. Overview Tab Enhancements
Monthly Calendar: Added TableCalendar to 
OverviewScreen
 to show monthly progress.
Challenges: Added a "Challenges" section with Daily, Weekly, Monthly, and Yearly challenges (e.g., "Pray all 5 prayers", "Read Surah Kahf").
4. Daily Prayer Tab Enhancements
Prayer Consistency: Added a "Prayer Consistency (Last 7 Days)" section below the weekly chart, displaying circular progress indicators for each prayer type.
Weekly Chart: Verified and ensured the weekly bar chart is displayed.
5. Feedback & Sound
Sound Effects: Integrated SystemSound.play(SystemSoundType.click) into 
FeedbackService
 to provide audio feedback for interactions, as "normal Android sounds".
Haptics: Continued use of Haptic Feedback for tactile response.
6. Deep Linking to Quran Verse
Feature: Clicking the "Daily Verse" in the Home tab now navigates directly to that specific verse in the Quran tab.
Implementation:
Added scrollable_positioned_list package for precise scrolling.
Refactored _SurahDetailPage to 
SurahDetailScreen
 with initialVerse support.
Added /quran-hadith/surah/:surahNumber route in GoRouter.
Updated 
DailyPrayerScreen
 to use context.go with the deep link.
7. Reminders & Settings Enhancements
Reminders:
Fixed interaction issue by using InputChip instead of Chip.
Added "Edit" functionality (tap to edit time).
Verified "Delete" functionality (tap X to delete).
Ensured immediate UI update upon adding/editing.
Settings:
Added ability to edit Name, Location, and Madhab directly in 
SettingsScreen
.
Added User Avatar display in 
SettingsScreen
 and 
DailyPrayerScreen
 AppBar.
Avatar dynamically changes based on gender (Man/Woman).
Assets:
Added 
assets/images/avatar_man.png
 and 
assets/images/avatar_woman.png
.
8. App Icon & Name
App Icon: Updated the launcher icon to use the "Man Praying" avatar (avatar_man.png).
App Name: Capitalized the app name to "Rafiq" in both Android and iOS configurations.
9. Phase 4 Refinements & API
Navigation:
Implemented 
DoubleBackToExit
 to handle Android back button (double tap to exit app from home tabs).
Azkar:
Requested Notification Permissions on startup.
Improved Reminder Deletion UI (larger 'X' icon, snackbar confirmation).
Quran:
Made entire verse container clickable for easier interaction.
Daily Prayer:
Refactored Scoring Logic:
Jamaa'a: 13 points (Green)
Fard: 10 points (Blue)
Late: 8 points (Orange)
Missed: 0 points (Red)
Added dialog to select prayer type/status.
Onboarding:
Enforced Location Selection validation (cannot proceed without selecting a city).
Hadith:
Integrated Dorar.net API for Hadith search.
Added Search Bar in Hadith tab.
Displays results with Narrator, Source, and Grade (colored by authenticity).
Verification Results
Automated Build
Ran flutter build apk --release successfully.
Output: √ Built build\app\outputs\flutter-apk\app-release.apk (59.7MB)
Manual Verification Checklist
 Onboarding: Location selection is mandatory.
 Navigation: Back button works as expected (double tap to exit).
 Azkar: Reminders can be deleted. Permissions requested.
 Quran: Tapping anywhere on verse toggles read status.
 Daily Prayer: Can select Jamaa/Fard/Late. Score updates correctly.
 Hadith: Can search for Hadiths using API.
 Launcher: App icon and name are correct.
Next Steps
Sound Assets: If specific custom sound files are desired later, they can be added to assets/sounds/ and 
FeedbackService
 updated to use audioplayers.
Data Persistence: Ensure TableCalendar reflects actual data (currently it's a visual calendar, can be enhanced to show dots for fully prayed days).
Challenge Logic: Implement actual tracking logic for challenges (currently placeholders or simple stats).