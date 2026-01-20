Rafiq App Implementation Plan (Updated)

Goal
Address critical gaps in the MVP: Overview Screen utility, Data Security (Backup/Restore), and Android Widgets.

Proposed Changes

1. Overview Screen Revamp (Priority 1)
   - **File**: `lib/features/overview/presentation/overview_screen.dart`
   - **Logic**:
     - Aggregate data from `SharedPreferences` (Daily Prayers, Qada, Quran verses, Azkar).
     - Calculate "Projected Finish Date" for Qada: `Date = Today + (TotalDebt / DailyAvgPayoff)`.
   - **UI**:
     - **Header**: "My Journey" summary card (Rank, Total Score).
     - **Section 1: Qada Insights**: "Est. Freedom Date: [Date]", "Current Rate: [X]/day".
     - **Section 2: Interactive Charts**: 
       - `BarChart` (Mon-Sun prayer count).
       - `PieChart` (Debt vs Paid).
     - **Section 3: Lifetime Stats**: Total Verses Read, Total Azkar Count.

2. Data Security & Backup (Priority 2)
   - **New Service**: `lib/core/services/backup_service.dart`
   - **Dependencies**: `share_plus`, `file_picker`, `path_provider`, `intl`.
   - **Logic**:
     - `exportData()`: Read all `SharedPreferences` keys -> Map -> JSON String -> Write to Temp File -> Share.
     - `importData()`: Pick File -> Read string -> Decode JSON -> Clear Prefs? -> WriteAll -> Restart App.
   - **UI**: Add "Backup & Restore" tile in `SettingsScreen`.

3. Home Screen Widgets (Priority 3)
   - **Dependencies**: `home_widget`.
   - **Android**:
     - `android/app/src/main/res/layout/widget_next_prayer.xml`: Layout for Next Prayer.
     - `android/app/src/main/java/.../WidgetProvider.kt`: Kotlin logic to update widget.
   - **Flutter**:
     - `updateWidget()`: Method called whenever data changes (e.g., prayer marked done).

Verification Plan
- **Overview**: Check if "Projected Date" changes when I pay off a Qada prayer.
- **Backup**: Export data, delete app data (Clear Storage), Import data, verify everything is back.
- **Widget**: Add widget to home screen, mark prayer as done in app, verify widget updates.
