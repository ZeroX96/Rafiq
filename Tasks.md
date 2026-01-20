Rafiq App Development Task List

Phase 1: Polish & Insights (Immediate Priority)
- [x] Overview Tab Revamp
    - [x] Calculate & Show "Estimated Completion Date" for Qada
    - [x] Show "Daily Average" cleanup rate
    - [x] Add "Total Lifetime Logged Prayers"
    - [x] Add Charts: Weekly Prayer Consistency (Bar), Qada Payoff Progress (Pie)
    - [x] Add "Badges Earned" section summary
- [x] Data Security & Backup
    - [x] Create `BackupService` to serialize all `SharedPreferences` to JSON
    - [x] Implement "Export Data" (Share Sheet with JSON file)
    - [x] Implement "Restore Data" (Simple Import)
    - [ ] Add "Last Backup Date" indicator in Settings
- [x] Home Screen Widgets (Android)
    - [x] Setup `home_widget` package
    - [x] Create "Next Prayer" widget layout (XML)
    - [x] Create "Daily Progress" widget layout (XML)
    - [x] Implement Background Update Logic

Phase 2: Feature Completeness
- [x] Quran Audio Helper
    - [x] Add `just_audio` package (used `audioplayers`)
    - [x] Create `AudioService` for Quran (Integrated in screen)
    - [x] Add "Play" button in Surah Detail
    - [x] Stream audio from standard CDN (e.g., Alafasy)
- [ ] "Smart Plan" for Qada
    - [ ] Create "Plan Generator" in Qada Tab
    - [ ] Logic: "If I pray X extra per day, I finish in Y months"
    - [ ] Visualization: Show "Target Date" based on user selection

Phase 3: Community & Advanced (Future)
- [ ] Private "Dua Requests"
- [ ] Fasting Tracker
- [ ] Cloud Sync (Firebase)