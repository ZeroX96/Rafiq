Rafiq - Feature Documentation
📱 Currently Implemented Features
1. Onboarding & User Profile
Multi-step onboarding wizard (6 steps)
User profile setup: Name, Email (Gmail validation)
Gender selection: Boy, Man, Girl, Woman (with icons)
Madhab selection: Hanafi, Shafi, Maliki, Hanbali
Date of Birth picker with puberty age slider (9-18 years)
Menstruation tracking for females (3-10 days slider)
Location selection from pre-loaded cities list
Qada calculation options:
Calculate from puberty age
Enter duration (Years, Months, Weeks, Days)
Manual entry per prayer
Sunnah tracking preference toggle
PIN setup option for app security
Inspirational Islamic quotes on each step
2. Daily Prayer Screen (Home Tab)
Prayer times based on location (using Adhan library)
Prayer categorization:
Fard Prayers: Fajr, Dhuhr, Asr, Maghrib, Isha
Sunnah Prayers: Sunrise, Shafaa, Witr
Prayer status options: None, Fard, Jamaa (congregation), Late, Missed
Daily score calculation with gamification
Rank system: Muslim → Mu'min → Muttaqi → Siddiq → Shahid
Weekly progress chart (bar chart)
Daily Quran verse display with link to surah
Prayer time display with AM/PM format
3. Qada Debt Screen (Qada Tab)
Grouped prayer display:
Fard Prayers (Obligatory): Fajr, Dhuhr, Asr, Maghrib, Isha
Sunnah Prayers (Optional): Sunrise, Shafaa, Witr (if enabled)
Tap to decrement debt counter
Increment button for corrections
Progress pie chart showing paid percentage
Hide debt toggle for privacy
Rotating Islamic quotes about prayer
Timestamp tracking for each Qada payment
4. Quran & Hadith Screen (Quran Tab)
Surah list with Arabic and English names
Surah details: verse count, revelation type
Verse-by-verse reading with Arabic text
Verse read tracking with checkmarks
Deep linking to specific verses
Total verses read counter
Hadith tab with Forty Hadith an-Nawawi
Hadith API integration for searching
5. Azkar Screen (Azkar Tab)
Default Azkar: Subhan Allah, Alhamdulillah, Allahu Akbar, Astaghfirullah, La ilaha illallah
Customizable targets per Azkar
Counter widget with tap to increment
Lifetime Azkar counter
Daily reminders with time picker
Local notifications for Azkar reminders
Add/delete reminders
6. Overview Screen (Overview Tab)
Summary cards: Today's prayers, Verses read, Lifetime Azkar, Qada debt
Weekly prayer progress chart
Monthly calendar view
Challenges system:
Daily: Pray all 5 prayers
Weekly: Read Surah Kahf
Monthly: Complete Quran
3-Month: Learn 10 Hadith
6-Month: Fast 6 days of Shawwal
9-Month: Memorize Juz Amma
12-Month: Perform Umrah
Qada debt distribution display
Azkar progress bar
Auto-refresh when navigating to screen
7. Settings Screen
Profile editing: Name, Gender, Madhab
Location change option
PIN management: Set/Change/Remove
Theme toggle (follows system)
Data management:
Export data
Reset onboarding
Clear all data
8. Core Services
NotificationService: Prayer time notifications with "Prayed" and "Remind Later" actions
MissedPrayerService: Auto-adds missed prayers to Qada debt at startup and on app resume
SettingsService: Profile management with Riverpod
PinService: App lock functionality
QadaCalculator: Debt calculation with menstruation deduction
9. Navigation & UX
Bottom navigation bar with 5 tabs (swipeable)
Double-back-to-exit safety
GoRouter for declarative routing
Deep linking support
Custom app icon (tasbih-themed)
Light/Dark theme support
🔜 Remaining Features (From Discussions)
1. Prayer Notifications
 Schedule notifications for each prayer time
 Handle "Prayed" action to mark prayer as done
 Handle "Remind Later" action (reschedule after 30 mins)
 Pre-prayer reminders (e.g., 15 mins before)
2. Qada Smart Plan
 Calculate and display "pray X extra Qada with every Fard" suggestion
 Progress tracking toward debt-free goal
3. Enhanced Quran Features
 Bookmark verses
 Audio recitation playback
 Translation support (English, Urdu, etc.)
 Juz navigation
4. Community Features (Discussed)
 Anonymous prayer groups
 Sharing progress with trusted friends
 Dua requests
5. Notifications Enhancement
 Escalating notification intensity
 Missed prayer notifications with motivational messages
 Weekly progress summary notification
6. Data Synchronization
 Cloud backup (Firebase/Google Drive)
 Multi-device sync
 Export to PDF/CSV
💡 Possible Future Features
A. Prayer Enhancements
Qibla compass integration
Mosque finder with GPS
Iqama time tracking for local mosques
Prayer time widgets for home screen
Apple Watch / Wear OS companion app
Sujood counter with phone placement detection
Salah guide with step-by-step instructions for beginners
B. Quran Features
Memorization mode with repetition tracking
Tajweed rules highlighting
Multiple reciter audio options
Word-by-word translation
Tafsir integration
Quran quiz for memorization testing
Reading plans (complete in 30/60/90 days)
Ayat bookmarking with notes
C. Hadith Features
Multiple collections: Bukhari, Muslim, Tirmidhi, etc.
Daily Hadith notification
Hadith categories by topic
Favorite hadith collection
Share hadith as image cards
D. Azkar Features
Morning/Evening Azkar collections
After-salah Azkar automatic suggestions
Dua collections by category (travel, eating, etc.)
Audio Azkar with native pronunciation
Azkar widgets for quick access
E. Fasting Features
Ramadan tracker with suhoor/iftar times
Voluntary fasting tracker (Monday/Thursday, White days)
Fasting debt tracker (missed Ramadan days)
Suhoor/Iftar reminders
F. Charity Features
Zakat calculator
Sadaqah tracker
Charity goal setting
Islamic finance tips
G. Hajj/Umrah Features
Hajj planning checklist
Umrah guide with step-by-step
Duas for Hajj/Umrah
Miqat calculator
H. Learning Features
Islamic knowledge quizzes
Arabic alphabet learning
99 Names of Allah with meanings
Prophet stories collection
Islamic calendar events (Eid, Muharram, etc.)
I. Social Features
Family group for tracking together
Accountability partner system
Anonymous community chat for support
Imam/Scholar Q&A integration
Local community events
J. Gamification Extensions
Achievement badges (100-day streak, Quran completion, etc.)
Leaderboards (optional, anonymous)
Daily/Weekly challenges with rewards
Milestone celebrations with animations
Personal best records
K. Analytics & Insights
Prayer consistency heatmap
Best prayer time analysis
Monthly/Yearly reports
Qada repayment projections
Spiritual growth graph
L. Accessibility Features
Screen reader support
Large text mode
High contrast theme
Voice control for counters
Multiple languages (Arabic, Urdu, Turkish, etc.)
M. Integration Features
Google Calendar sync for prayer times
Apple Health integration for mindfulness minutes
Smart home integration (dim lights for prayer)
Islamic banking app integrations
N. Offline Features
Full offline Quran and Hadith
Offline prayer times calculation
Local data storage with encryption
📊 Feature Priority Matrix
Priority	Feature	Impact	Effort
🔴 High	Prayer time notifications	High	Medium
🔴 High	Cloud backup	High	High
🟡 Medium	Quran audio	Medium	Medium
🟡 Medium	Qibla compass	Medium	Low
🟡 Medium	Fasting tracker	Medium	Medium
🟢 Low	Community features	High	High
🟢 Low	Gamification badges	Low	Medium
Last Updated: December 18, 2025




Summary of Contents
01_IMPLEMENTED_FEATURES.md
Onboarding & User Profile (6 steps, all fields)
Daily Prayer Screen (prayers, gamification, charts)
Qada Debt Screen (grouped prayers, progress)
Quran & Hadith Screen (reading, tracking)
Azkar Screen (counters, reminders)
Overview Screen (stats, challenges)
Settings Screen (profile, security, data)
Core Services (notifications, missed prayers, calculator)
Technical Architecture (dependencies, file structure)
02_REMAINING_FEATURES.md
Prayer Notifications System
Qada Smart Plan
Enhanced Quran Features
Community Features
Notifications Enhancement
Cloud Sync & Backup
03_POSSIBLE_FUTURE_FEATURES.md
Prayer Enhancements (Qibla, Mosque finder, Widgets)
Quran Features (Audio, Memorization, Tafsir)
Hadith Features (All collections, Daily hadith)
Azkar Features (All categories, Audio)
Fasting Features (Ramadan, Voluntary, Debt)
Charity Features (Zakat, Sadaqah)
Hajj/Umrah Features
Learning Features (Arabic, 99 Names)
Social Features (Family, Community)
Gamification (Badges, Leaderboards)
Analytics & Insights
Accessibility & Localization
Integrations (Calendar, Health, Smart Home)
Offline & Security