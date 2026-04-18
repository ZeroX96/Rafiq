# Rafiq – Feature Documentation

Welcome to the Rafiq App Feature List!  
This document outlines all current, planned, and potential future features. Please use this list to track progress, discuss priorities, and share your product vision.

---

## 📱 Implemented Features

### 1. Onboarding & User Profile
- **Multi-step onboarding** (6 steps) covering:
  - Name, Email (with Gmail validation)
  - Gender selection (Boy, Man, Girl, Woman) with icons
  - Madhab selection (Hanafi, Shafi, Maliki, Hanbali)
  - Date of birth, puberty age slider (9–18 years)
  - Menstruation tracking for females (3–10 days slider)
  - Location from preloaded city list
  - Qada calculation options:
    - From puberty age
    - Enter duration (years, months, weeks, days)
    - Manual entry per prayer
  - Sunnah tracking preference
  - PIN setup for additional security
- **Inspirational Islamic quotes** on each onboarding step

### 2. Daily Prayer Screen (Home Tab)
- Accurate prayer times based on location (Adhan library)
- Prayer types:  
  - **Fard**: Fajr, Dhuhr, Asr, Maghrib, Isha  
  - **Sunnah**: Sunrise, Shafaa, Witr (if enabled)
- Mark prayer status: None, Fard, Congregation (Jamaa), Late, Missed
- Daily score and gamification system with rank progression:
  - Muslim → Mu'min → Muttaqi → Siddiq → Shahid
- Visual feedback:
  - Weekly progress bar chart
  - Daily Quran verse display with deep-linking to the Surah
- AM/PM time display

### 3. Qada Debt Screen (Qada Tab)
- Grouped prayer display: Fard and Sunnah
- Tap to increment/decrement debt counters per prayer
- Progress pie chart (percentage paid)
- Hide debt toggle (privacy)
- Rotating Islamic quotes about prayer
- Timestamp recorded for each Qada marked as paid

### 4. Quran & Hadith Screen (Quran Tab)
- Surah list (Arabic & English)
- Surah details: verse count, revelation type
- Verse-by-verse reading (with Arabic)
- Progress tracking: checkmarks and total verses read
- Deep-link to any verse
- Forty Hadith an-Nawawi collection
- Hadith API integration (search)

### 5. Azkar Screen (Azkar Tab)
- Default Azkar (Subhan Allah, etc.)
- Custom targets per Azkar
- Counter widget (tap to increment)
- Lifetime Azkar counter
- Daily reminder configuration (with notifications)
- Manage (add/delete) reminders

### 6. Overview Screen (Overview Tab)
- Summary cards:
  - Today’s prayers, Verses read, Lifetime Azkar, Qada debt
- Weekly progress chart & monthly calendar view
- **Challenges system:**
  - Daily: All five prayers
  - Weekly: Read Surah Kahf
  - Monthly: Complete Quran
  - 3/6/9/12-Month: Incremental spiritual goals
- Qada debt visualization
- Azkar progress bar
- Auto-refresh on navigation

### 7. Settings Screen
- Edit profile (Name, Gender, Madhab)
- Change location
- PIN management: Set/Change/Remove
- Theme toggle (system/auto)
- Data management:
  - Export data
  - Reset onboarding / Clear all data

### 8. Core Services
- **NotificationService:** Prayer reminders with actionable notifications (“Prayed” / “Remind Later”)
- **MissedPrayerService:** Auto-Qada for missed prayers on startup & resume
- **SettingsService:** Profile/data management (with Riverpod)
- **PinService:** App lock
- **QadaCalculator:** Debt calculation (includes menstruation deduction)

### 9. Navigation & UX
- Bottom navigation (5 tabs, swipeable)
- Double-back exit safety
- GoRouter for navigation & deep linking
- Custom tasbih-themed app icon
- Light/Dark mode

---

## 🔜 Features In Progress / Under Discussion

### 1. Prayer Notifications (Advanced)
- Schedule per prayer
- “Prayed” action, mark prayer as completed
- “Remind Later” (snooze 30 mins)
- Pre-prayer reminders (15 min before)

### 2. Qada Smart Plan
- Smart suggestions: “Pray X extra Qada with each Fard”
- Progress tracking to debt-free status

### 3. Enhanced Quran Tools
- Bookmarks & notes per verse
- Audio recitation
- Multiple translations (EN, UR, etc.)
- Juz navigation

### 4. Community Features
- Anonymous prayer groups
- Progress sharing with friends
- Dua request system

### 5. Notifications Enhancement
- Escalating notification intensity
- Motivational messages for missed prayers
- Weekly summary reports

### 6. Data Synchronization
- Cloud backup: Firebase/Google Drive
- Multi-device sync
- Export as PDF/CSV

---

## 💡 Possible Future Features

### A. Prayer Enhancements
- Qibla compass
- Mosque finder (GPS)
- Iqama time tracking (local)
- Home screen prayer widgets
- Wearable companion app (Apple Watch / Wear OS)
- Sujood counter (sensor-based)
- Salah guide for beginners (step-by-step)

### B. Quran Features
- Memorization & repetition mode
- Highlight Tajweed rules
- Multiple reciters
- Word-by-word translation
- Tafsir integration
- Quran quizzes
- Reading plans (30/60/90 days)
- Advanced verse bookmarks & notes

### C. Hadith Features
- Major collections (Bukhari, Muslim, Tirmidhi, etc.)
- Daily hadith reminder
- Topical categorization
- Favorite/save & image sharing

### D. Azkar Features
- Morning/evening collections
- Auto-suggestion after salah
- Dua organized by life scenario
- Audio with correct pronunciation
- Home screen widgets

### E. Fasting Features
- Ramadan tracker (suhoor/iftar times)
- Voluntary fasting (Monday/Thursday, White Days)
- Fasting debt tracking (missed Ramadan)
- Suhoor/iftar reminders

### F. Charity Features
- Zakat calculator
- Sadaqah goal tracker
- Charity milestones & Islamic finance tips

### G. Hajj/Umrah Features
- Planning checklist
- Interactive guides
- Dua list
- Miqat calculator

### H. Learning Features
- Quizzes & trivia
- Arabic alphabet learning
- 99 Names of Allah (with meanings)
- Prophets’ stories
- Islamic calendar events

### I. Social Features
- Family group tracking
- Accountability partners
- Anonymous peer chat
- Imam/Scholar Q&A
- Local events

### J. Gamification Extensions
- Achievement badges & leaderboards
- Daily/Weekly challenge rewards
- Milestone celebration animations
- Personal best logs

### K. Analytics & Insights
- Prayer consistency heatmap
- Best time analytics
- Monthly/yearly summaries
- Qada debt projection
- Spiritual growth graphs

### L. Accessibility & Localization
- Screen reader compatible
- Large text/high contrast themes
- Voice control
- Multilingual: Arabic, Urdu, Turkish, more

### M. Integration Features
- Google Calendar sync
- Apple Health integration
- Smart Home (prayer-friendly automation)
- Islamic banking integrations

### N. Offline Features
- Full offline content (Quran, Hadith)
- Local calculation of prayer times
- Encrypted local storage

---

## 📊 Feature Priority Matrix

| Priority   | Feature                  | Impact | Effort |
|------------|--------------------------|--------|--------|
| 🔴 High    | Prayer time notifications| High   | Medium |
| 🔴 High    | Cloud backup             | High   | High   |
| 🟡 Medium  | Quran audio              | Medium | Medium |
| 🟡 Medium  | Qibla compass            | Medium | Low    |
| 🟡 Medium  | Fasting tracker          | Medium | Medium |
| 🟢 Low     | Community features       | High   | High   |
| 🟢 Low     | Gamification badges      | Low    | Medium |

_Last Updated: December 18, 2025_

---

## 📁 Section Summaries

- **01_IMPLEMENTED_FEATURES.md**
  - Onboarding, Prayer, Qada, Quran & Hadith, Azkar, Overview, Settings, Core Services, Technical details
- **02_REMAINING_FEATURES.md**
  - Prayer notification system, Qada plan, enhanced Quran, community features, cloud sync
- **03_POSSIBLE_FUTURE_FEATURES.md**
  - All future categories above

---

> **For context & suggestions, see:** [GitHub Discussions](https://github.com/ZeroX96/Rafiq/discussions)
