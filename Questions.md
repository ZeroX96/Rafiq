30 Clarification Questions for Rafiq App
General & Privacy
Offline "Friends": You mentioned checking on friends but also strict offline mode. Does this mean tracking multiple people on the same device (e.g., family members sharing a tablet), or did you mean something else? this is a mistake, skip completely any features related to onlline connections or friends, lets keep this version fully offline only
Strict Offline: Can we use the internet once to download prayer time adjustments or Quran audio, or must the app be 100% disconnected forever? yes, for application calculation/timings and so on related needs can be downloaded anytime, i meant from the user prespective, the app should be 100% offline, but for the app to function it can use the internet anytime needed to download the needed data, for example prayer times can be downloaded anytime needed 
Data Export: Do you want users to be able to export their data (e.g., to a PDF or CSV) for their own backup since there is no cloud sync? yes, the user can export his data to a csv or json file
Security: Should the app require a PIN/Biometric lock to open, to keep prayer data private from others who might use the phone? yes, the user can set a pin or biometric lock to open the app 
Prayer Tracking (Tab 1)
Calculation Method: Which prayer time calculation method should be the default? (e.g., MWL, ISNA, Umm al-Qura). configurable by user 
Location: Should the app use GPS for prayer times, or should the user manually select their city from a local database (to avoid location permission)? yes, the user can select his city from a local database 
Madhab: Should we support only Hanafi and Shafi'i (Standard) for Asr time, or others as well? configurable by user
Statuses: Are the statuses just "Prayed", "Late", "Missed"? What about "Excused" (for women)? yes if a woman is excused from prayer she can mark it as excused 
Reminders: Since it's offline, should we use system local notifications? Do you want custom Adhan sounds bundled (increasing app size)? no, the app should use system local notifications and can use custom adhan sounds from the user specificly 
Pre-notification: Do you want a reminder before the prayer time (e.g., "15 mins to Maghrib")? yes, the app should have a pre-notification feature 
Qada/Debt (Tab 2)
Skip Option: If a user skips the Qada calculator, should the Qada tab disappear entirely, or just show "0 Debt"? no, the Qada tab should not disappear entirely, show 0 debt and if he missed a prayer it should be added to the debt to keep track of the debt after he starts using the app 
Calculation Logic: For the calculator, if a user says they missed "10 years", do we assume 365 days or lunar years (354 days)? yes, the app should assume lunar years 
Input Granularity: Can users enter missed prayers specifically (e.g., "I missed 50 Fajr") or only by time period (e.g., "2 years")? yes, the user can enter missed prayers specifically so he can decide if need the app to calculate or set a specific number of prayers missed 
Auto-Increment: If a user misses a prayer in Tab 1, should it automatically add to the Debt in Tab 2? yes, the app should automatically add to the debt if a user misses a prayer, this should be updated/calcualted at end of every day at 11:30 pm
Negative Debt: Can a user have "extra" prayers (positive balance) or does it stop at 0? no, the app should not allow a user to have a positive balance 
Quran & Hadith (Tab 3)
Text Source: Which script style do you prefer? (Uthmani, Indo-Pak, etc.)? uthmani
Translation: Which English translation should be bundled? (e.g., Sahih International, Yusuf Ali). sahih international
Audio: Since it's offline, should we omit audio to keep the app size small (<100MB), or bundle a few selected Surahs? yes, the app should omit audio to keep the app size small and can be downloaded anytime needed by the user as a separate download mp3 file 
Bookmark: Should the bookmark be automatic (last read) or manual? automatic
Hadith: Which books should be included? (Sahih Bukhari, Muslim, 40 Hadith Nawawi)? sahih bukhari and sahih muslim
Azkar (Tab 4)
Custom Azkar: Can users create their own Azkar with their own defined rewards? yes, the user can create his own azkar with his own defined rewards 
Rewards: You mentioned "3000 trees". Should we have a predefined list of rewards (e.g., "Palace in Jannah") linked to specific Azkar? yes, the user can create his own rewards for azkar 
Counter: Should the counter have a sound/vibration feedback on every tap? yes, the app should have a sound/vibration feedback on every tap 
Limits: Is there a daily target for Azkar (e.g., "Morning Adhkar completed")? yes, the user can set a daily target for azkar 
User Overview (Tab 5)
Friend View: If we go with the "Local Multi-Profile" approach, should the overview show a comparison list (Leaderboard style) of all local users? no, the app should not have a comparison list of all local users. the app will not be Local Multi-Profile 
Streaks: Does a "streak" require all 5 prayers to be on time, or just prayed? yes, the user can set a streak for prayers
Privacy: In the overview, can a user "hide" their debt stats from the summary screen (in case someone looks over their shoulder)? yes, the user can hide his debt stats from the summary screen 
Design & Polish
Theme: Do you want a specific color palette? (e.g., Green/Gold, Blue/White, Dark Mode default)? Green/Gold/Blue/White
Animations: Should the "Tree Planting" be a complex animation or just a static icon update? static icon update
Language: Is English-only sufficient for the MVP, or do we need Arabic UI support immediately? English only