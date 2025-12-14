Rafiq will be a mobile app for praying muslim prayers missed, track your current prayers, support you and help you keep consistent in your prayers. Rafiq is your companion to heaven.
I need to develop this flutter application and need your help in that. 

**Prayer Logging & Motivation:** The app will prompt users at each prayer time to confirm whether they prayed (e.g. a simple yes/no/late check-in). For example, Just Pray lets users “log each prayer as on time or late with simple, honest check-ins” to build discipline . Users could enable reminders (up to three per prayer, customizable timing and tone ) and motivational messages (e.g. Quranic verses, hadith, or progress alerts). A gamified reward system (points, badges, levels, or unlocking content) will encourage consistency. (For instance, Namaz Checkin awards points and badges for each verified prayer .) Users can choose to track only the five daily fardh prayers or also optional (nafl/sunnah) prayers. Progress is shown through streaks and reports: users earn a “prayer streak” for consecutive days of full prayers , and weekly/ monthly summary charts show overall adherence. (If desired, the user can hide streak counters to avoid undue pressure.) Additional features might include a personal “spiritual garden” (like Just Pray’s Garden of Deeds) where each logged prayer makes a virtual garden flourish , and a private journal/calendar to review history or log make-up prayers . In all notifications and AI-feedback (e.g. an “AI Prayer Coach”), the tone will be supportive and positive – echoing guidance like Just Pray’s “always supportive, never judgmental” approach. users can do azkar where a list of azkar the user can press to count so he/she can memories him/her self of how good he/she is and to get some energy so for example if i said there is no god but allah and mohammed is the messenger of allah, i get a tree planted in heaven so the user can check the summary and see he has 3000 trees in heaven, similar azkars with their rewards and the user can have the option to add more azkars and define their reward

Logging method: Manual check-in at prayer time (yes/no/late and in messged or alone prompts). Daily summaries ask if all prayers were done, with an option to “remind me later”. Missed prayers by day-end automatically add to the Qada counter.

Reminders: Configurable alerts before/during/after each prayer . Users choose gentle vs. firm tone, notification sound, or even adhan audio.

Rewards/Gamification: Optional points, badges or levels for consistency (e.g. “10-day streak badge”, unlocking a dua or verse for milestones). Namaz Checkin, for example, “rewards, badges, and levels” for prayer check-ins .

Progress Tracking: Display streak count and on-time percentage, plus weekly email/app reports. Progress charts (bar graphs, percent complete, etc.) show consistency. Encourage focus on small wins (research shows breaking big goals into smaller tasks boosts motivation ).

Motivational Content: Daily inspirational quotes, Quran verses or duas (e.g. “Dua of the Day”, “Ayah of the Day”) can pop up. An optional “Garden of Deeds” or score bar grows with each prayer .

Missed-Prayer (Qadha) Calculator: On onboarding, the user chooses a scenario or enters custom data. For example, like the “Qadaa Prayer Calculator” app, users enter their gender, madhhab, birthdate and age at puberty to estimate total missed prayers . The user can decide to assume the worst-case (no prayers at all) or input any prayers they did perform. A manual input mode lets users log past missed prayers by date or count (as in Qaza Namaz Calculator) . The app then shows how many qada prayers remain for each of the five daily prayers (e.g. “Dhuhr: 1000 missed”).

Debt Visualization: Show total missed prayers broken down by prayer type and time period. Present this as a large total debt, but immediately break it into manageable milestones (e.g. “500/1000 Dhuhr recovered = 50%”). Psychological research supports breaking big goals into small subgoals to boost confidence .

Catch-up Planning: Offer preset plans (e.g. pray 2 extra Salah per day or add 1 extra daily prayer).

The app might calculate a feasible schedule to clear the backlog (e.g. catch-up 20 rak’ahs per day). For reference, the Qaza Namaz app even suggests a 20-rakah daily routine with shortened recitations to make up long delays (this could be presented as an optional guideline, not enforced).

Progress Tracking: As the user prays current and make-up prayers, decrement the debt. Display progress as both absolute numbers and percentages (e.g. “30% of your qada cleared”). Users can hide or reset counters if the totals feel overwhelming. Weekly or monthly challenges (e.g. “make up 15 prayers this week”) can help chip away at the debt.

User Control: Because huge debt can be discouraging, include options to “skip” or “pause” debt notifications, or let users hide the debt tracker. Display motivational Islamic reminders (from Qur’an/hadith) about Allah’s mercy and the value of any effort, to reduce anxiety about missed prayers (since scholars note that missed prayers should be made up as soon as possible ).

Community & Support: Social features are entirely optional. Users may choose to share progress or request support in three ways:

Trusted Groups: Allow joining private prayer groups (via code or invite) where users see each other’s status and encourage each other without judgment. For example, the Mizan app lets friends “join private salah groups” to view and cheer one another . Users could celebrate milestones together (e.g. group challenges of “5 days straight of praying”). All group features should emphasize humility (e.g. “with Allah’s help” badges) to avoid pride.

Anonymous Community: Offer an opt-in anonymous forum or chatroom (moderated) where people can ask questions or share struggles. Ensure strict no-shaming policies. Perhaps use Islamic counselor volunteers or mentors to oversee discussions.

Buddy Support: Let users optionally designate close friends/family as “support contacts.” With user permission, send periodic status updates via WhatsApp/Telegram/Facebook Messenger (e.g. “X has prayed 4/5 prayers today”), or request a dua/encouragement message from them. (All such sharing is opt-in: as soon as the user enables it, only minimal info is shared, respecting privacy.)

Leaderboards or public comparison should be used very cautiously (many would find gamified competition inappropriate in a spiritual context). At most, allow opt-in “friendly challenges” between consenting users (e.g. “I will out-earn your prayer points” used playfully). To prevent shame, the app will remind users that any improvement is by Allah’s grace, and that humility is the goal.

Technical & Privacy: The app will be developed in Flutter for cross-platform (Android-first, then iOS/web). All sensitive data (prayer logs, user settings) is stored locally with encryption (e.g. using SQLCipher on Android and iOS secure storage ). By default, no 

data is uploaded or shared; features like backups or cloud sync are optional. For example, one app explicitly states “All your data stays on your device and is never shared” . An offline mode ensures full functionality without internet (users can log prayers and view counters completely offline).

Privacy Controls: All sharing (email, WhatsApp/Facebook/Telegram messages, group invites) is entirely opt-in. Use only secure, end-to-end encrypted channels if sharing outside the app. The user can delete their data anytime and control what is visible: as Mizan notes, “Your prayer data stays private and visible only to you and your chosen group” .

Customization: Provide language options (initially English, with Arabic added later, plus possible others). Prayer time calculations should be accurate and may be adjusted per madhhab if needed. A setting for madhhab (Hanafi/Shafi’i/Maliki/Hanbali) can guide any jurisprudential differences. (In fact, some Qadha apps support all schools of thought .) Ultimately, an advisory board of trusted Islamic scholars will review all religious guidance, qada calculations, and notifications for correctness.

Quran & Azkar Integration: To support users’ spirituality, the app will include an in-app Quran reader (text, translation, and optional audio playback of Surahs). It can also supply daily Azkar (adhkar) reminders and a tasbih (dhikr) counter. For example, apps like Azkar – Adhan & Prayer include Morning & Evening Athkar sections and a full Qur’an with audio, tafsir and translations . We can adopt similar features:

Daily Athkar: Remind users of morning/evening du’as and nightly adhkar. Let them set times for duatimer popups. Include a library of common supplications and allow customization.

Quranic Content: Show a rotating “Verse of the Day” or daily dua with reminder. Facilitate Quran study by offering reading plans or reflecting on short passages. Azkar app even provides “Dua of the Day” and “Ayah of the Day” for daily inspiration . 

Dua Requests: Enable sending or receiving duas from friends (i.e. “Could you pray for my consistency?” button).

Platforms, Languages, & Business Model: 

The initial release will target Android (using Flutter, which eases future iOS/web deployment). The first language is English; Arabic and others can be added once core features are solid. The app will be free to install (likely open-source or donation-supported) to maximize access; any funding model (e.g. optional premium features or non-intrusive ads) will be chosen carefully to keep the app spiritually focused.

Scholar Advisory: Finally, we’ll form an advisory board of qualified Islamic scholars to review religious content (qada math, messaging tone, motivators, etc.). They will ensure guidance aligns with consensus (for example, noting that even deliberate missed prayers are generally advised to be made up with repentance). This board will also help refine sensitive tone (e.g. compassionate encouragement for end-of-life concerns) so the app supports users without overstepping religious guidelines.

Together, these features create a supportive, private system for Muslims to renew and track their prayer habits, make up for past misses, and stay spiritually motivated each day .

Sources: Descriptions and design ideas are informed by existing apps and research. For example, Niya Salah Tracker highlights swipe-based prayer logging and Qada calendars , Mizan demonstrates private accountability groups and streaks , and studies show breaking goals into smaller steps aids motivation . Industry best-practices (e.g. local encrypted data ) guide the technical design. All suggestions above synthesize these sources with the user’s requirements.



Let's start with the fully offline version, i need the app to have multiple tabs or screens, one for daily prayer tracking, the second for debt payout tracking, third is for quran and hadith reading tracking, fourth is for azkar and the fifth is for a user overview showing summary of all his progress/prayers/readings/azkar



Comprehensive Prayer-Tracking App Features
Prayer Logging & Motivation: The app will prompt users at each prayer time to confirm whether they prayed (e.g. a simple yes/no check-in). For example, Just Pray lets users “log each prayer as on time or late with simple, honest check-ins” to build discipline[1]. Users could enable reminders (up to three per prayer, customizable timing and tone[2]) and motivational messages (e.g. Quranic verses, hadith, or progress alerts). A gamified reward system (points, badges, levels, or unlocking content) will encourage consistency. (For instance, Namaz Checkin awards points and badges for each verified prayer[3].) Users can choose to track only the five daily fardh prayers or also optional (nafl/sunnah) prayers. Progress is shown through streaks and reports: users earn a “prayer streak” for consecutive days of full prayers[4], and weekly/ monthly summary charts show overall adherence. (If desired, the user can hide streak counters to avoid undue pressure.) Additional features might include a personal “spiritual garden” (like Just Pray’s Garden of Deeds) where each logged prayer makes a virtual garden flourish[5], and a private journal/calendar to review history or log make-up prayers[6]. In all notifications and AI-feedback (e.g. an “AI Prayer Coach”), the tone will be supportive and positive – echoing guidance like Just Pray’s “always supportive, never judgmental” approach[7].
•	Logging method: Manual check-in at prayer time (yes/no prompt). Daily summaries ask if all prayers were done, with an option to “remind me later”. Missed prayers by day-end automatically add to the Qada counter.
•	Reminders: Configurable alerts before/during/after each prayer[2]. Users choose gentle vs. firm tone, notification sound, or even adhan audio.
•	Rewards/Gamification: Optional points, badges or levels for consistency (e.g. “10-day streak badge”, unlocking a dua or verse for milestones). Namaz Checkin, for example, “rewards, badges, and levels” for prayer check-ins[3].
•	Progress Tracking: Display streak count and on-time percentage, plus weekly email/app reports. Progress charts (bar graphs, percent complete, etc.) show consistency. Encourage focus on small wins (research shows breaking big goals into smaller tasks boosts motivation[8][3]).
•	Motivational Content: Daily inspirational quotes, Quran verses or duas (e.g. “Dua of the Day”, “Ayah of the Day”) can pop up. An optional “Garden of Deeds” or score bar grows with each prayer[5].
Missed-Prayer (Qadha) Calculator: On onboarding, the user chooses a scenario or enters custom data. For example, like the “Qadaa Prayer Calculator” app, users enter their gender, madhhab, birthdate and age at puberty to estimate total missed prayers[9]. The app can assume the worst-case (no prayers at all) or allow the user to input any prayers they did perform. A manual input mode lets users log past missed prayers by date or count (as in Qaza Namaz Calculator)[10]. The app then shows how many qada prayers remain for each of the five daily prayers (e.g. “Dhuhr: 1000 missed”).
•	Debt Visualization: Show total missed prayers broken down by prayer type and time period. Present this as a large total debt, but immediately break it into manageable milestones (e.g. “500/1000 Dhuhr recovered = 50%”). Psychological research supports breaking big goals into small subgoals to boost confidence[8].
•	Catch-up Planning: Offer preset plans (e.g. pray 2 extra Salah per day or add 1 extra daily prayer). The app might calculate a feasible schedule to clear the backlog (e.g. catch-up 20 rak’ahs per day). For reference, the Qaza Namaz app even suggests a 20-rakah daily routine with shortened recitations to make up long delays[11] (this could be presented as an optional guideline, not enforced).
•	Progress Tracking: As the user prays current and make-up prayers, decrement the debt. Display progress as both absolute numbers and percentages (e.g. “30% of your qada cleared”). Users can hide or reset counters if the totals feel overwhelming. Weekly or monthly challenges (e.g. “make up 15 prayers this week”) can help chip away at the debt.
•	User Control: Because huge debt can be discouraging, include options to “skip” or “pause” debt notifications, or let users hide the debt tracker. Display motivational Islamic reminders (from Qur’an/hadith) about Allah’s mercy and the value of any effort, to reduce anxiety about missed prayers (since scholars note that missed prayers should be made up as soon as possible[12][13]).
Community & Support: Social features are entirely optional. Users may choose to share progress or request support in three ways:
•	Trusted Groups: Allow joining private prayer groups (via code or invite) where users see each other’s status and encourage each other without judgment. For example, the Mizan app lets friends “join private salah groups” to view and cheer one another[14]. Users could celebrate milestones together (e.g. group challenges of “5 days straight of praying”). All group features should emphasize humility (e.g. “with Allah’s help” badges) to avoid pride.
•	Anonymous Community: Offer an opt-in anonymous forum or chatroom (moderated) where people can ask questions or share struggles. Ensure strict no-shaming policies. Perhaps use Islamic counselor volunteers or mentors to oversee discussions.
•	Buddy Support: Let users optionally designate close friends/family as “support contacts.” With user permission, send periodic status updates via WhatsApp/Telegram/Facebook Messenger (e.g. “X has prayed 4/5 prayers today”), or request a dua/encouragement message from them. (All such sharing is opt-in: as soon as the user enables it, only minimal info is shared, respecting privacy.)
Leaderboards or public comparison should be used very cautiously (many would find gamified competition inappropriate in a spiritual context). At most, allow opt-in “friendly challenges” between consenting users (e.g. “I will out-earn your prayer points” used playfully). To prevent shame, the app will remind users that any improvement is by Allah’s grace, and that humility is the goal.
Technical & Privacy: The app will be developed in Flutter for cross-platform (Android-first, then iOS/web). All sensitive data (prayer logs, user settings) is stored locally with encryption (e.g. using SQLCipher on Android and iOS secure storage[15]). By default, no data is uploaded or shared; features like backups or cloud sync are optional. For example, one app explicitly states “All your data stays on your device and is never shared”[16]. An offline mode ensures full functionality without internet (users can log prayers and view counters completely offline).
•	Privacy Controls: All sharing (email, WhatsApp/Facebook/Telegram messages, group invites) is entirely opt-in. Use only secure, end-to-end encrypted channels if sharing outside the app. The user can delete their data anytime and control what is visible: as Mizan notes, “Your prayer data stays private and visible only to you and your chosen group”[17].
•	Customization: Provide language options (initially English, with Arabic added later, plus possible others). Prayer time calculations should be accurate and may be adjusted per madhhab if needed. A setting for madhhab (Hanafi/Shafi’i/Maliki/Hanbali) can guide any jurisprudential differences. (In fact, some Qadha apps support all schools of thought[16].) Ultimately, an advisory board of trusted Islamic scholars will review all religious guidance, qada calculations, and notifications for correctness.
Quran & Azkar Integration: To support users’ spirituality, the app will include an in-app Quran reader (text, translation, and optional audio playback of Surahs). It can also supply daily Azkar (adhkar) reminders and a tasbih (dhikr) counter. For example, apps like Azkar – Adhan & Prayer include Morning & Evening Athkar sections and a full Qur’an with audio, tafsir and translations[18]. We can adopt similar features:
- Daily Athkar: Remind users of morning/evening du’as and nightly adhkar. Let them set times for dua-timer popups. Include a library of common supplications and allow customization.
- Quranic Content: Show a rotating “Verse of the Day” or daily dua with reminder. Facilitate Quran study by offering reading plans or reflecting on short passages. Azkar app even provides “Dua of the Day” and “Ayah of the Day” for daily inspiration[19].
- Dua Requests: Enable sending or receiving duas from friends (i.e. “Could you pray for my consistency?” button).
Platforms, Languages, & Business Model: The initial release will target Android (using Flutter, which eases future iOS/web deployment). The first language is English; Arabic and others can be added once core features are solid. The app will be free to install (likely open-source or donation-supported) to maximize access; any funding model (e.g. optional premium features or non-intrusive ads) will be chosen carefully to keep the app spiritually focused.
Scholar Advisory: Finally, we’ll form an advisory board of qualified Islamic scholars to review religious content (qada math, messaging tone, motivators, etc.). They will ensure guidance aligns with consensus (for example, noting that even deliberate missed prayers are generally advised to be made up with repentance[13]). This board will also help refine sensitive tone (e.g. compassionate encouragement for end-of-life concerns) so the app supports users without overstepping religious guidelines.
Together, these features create a supportive, private system for Muslims to renew and track their prayer habits, make up for past misses, and stay spiritually motivated each day[20][9].
Sources: Descriptions and design ideas are informed by existing apps and research. For example, Niya Salah Tracker highlights swipe-based prayer logging and Qada calendars[20], Mizan demonstrates private accountability groups and streaks[14][17], and studies show breaking goals into smaller steps aids motivation[8]. Industry best-practices (e.g. local encrypted data[16][15]) guide the technical design. All suggestions above synthesize these sources with the user’s requirements.
________________________________________
[1] [2] [5] [6] [7] Just Pray - Apps on Google Play
https://play.google.com/store/apps/details?id=com.justprayapp.justpray&hl=en_US
[3] ‎Namaz Checkin App - App Store
https://apps.apple.com/pl/app/namaz-checkin/id6473462733
[4] [14] [17] ‎Mizan-Be consistent with salah App - App Store
https://apps.apple.com/us/app/mizan-be-consistent-with-salah/id6745764531
[8] The Science of Goal Setting: How Goals Drive Brain & Behavior – DAVRON
https://www.davron.net/the-science-of-goal-setting-how-goals-drive-brain-behavior/
[9] [16] ‎Qadaa Prayer Calculator App - App Store
https://apps.apple.com/ca/app/qadaa-prayer-calculator/id6748410215
[10] [11] Qaza Namaz Calculator - Apps on Google Play
https://play.google.com/store/apps/details?id=com.qazanamaz.mhpartner&hl=en_US
[12] [13] Ruling on making up missed prayers - Islam Question & Answer
https://islamqa.info/en/answers/13664
[15] Guarding User Data in Mobile Apps: Best Practices for Security > Women Who Code
https://womenwhocode.com/blog/guarding-user-data-in-mobile-apps-best-practices-for-security/
[18] [19] ‎Azkar - اذكار : Athan & Prayer App - App Store
https://apps.apple.com/us/app/azkar-%D8%A7%D8%B0%D9%83%D8%A7%D8%B1-athan-prayer/id1454509502
[20] ‎Niya: Muslim prayer tracker App - App Store
https://apps.apple.com/us/app/niya-muslim-prayer-tracker/id1668179563


in the very begining, if i ddnt put any name or so it accepts and goes on, this is wrong
the phone back button dosn't work
enter button doent work, fix
you dont ask about the femail period in which no pray required, fix this
signing in shall be based on a gmail account thats valid, add this
the overview tab is useles, its empty, no calculations and new additions are not reflected to counts, fix this
in the very beginning during asking about the name, put a part of quran, and add hadith that the first thinr we will be asked is about salah. and put some supporting and energetic text quoutes of islamic scientests. during putting the user name, it can contain only alphabets no numbers or special characters.
in the second screen put another collection of islamic text quran/hadith or so on. and include the worman period, and its usuall number of days so to be correctly calculated in the debt calculation
in the age and puberty, put hadith that رُفِع القلمُ عنْ ثلاثةٍ عنِ الصغيرِ حتى يبلُغَ وعَنِ النائمِ حتى يستيقظَ وعنِ المصابِ حتى يُكشفَ عنهُ
in the setup summarz no 5, allow the user to correct or change a calculation of the estimated debt

after that in the prayers tab, the daily score is not correctly working, its const at 60% and also coorect and fix the weekly progress charts and add the shafaa and witr in daily prayers.

in the qada tab, make the whole section is a button for each prayerso if a user clicked at any part of this area it's counted as done, and keep the pluss as option to fix if mestaken

in the quran-hadith section its totally empty, no data, heck for an api to get the data from online. and in the quran tab next to each verses a check so the user can tick if he read it and count these in the top of the quran tab and in the overview tab to say you read 3004 verses since 12-2-2020 for exmaple

in the azkar tab, add an overall counter so even if the counter of each azkar is reset, the overall keeps counting, this info to be shown also in the user overview. and fixthe add reminder button, its useless. so user can set a specific reminder at a specific time of his own need. the reminders can be shown in the user overview section

again also fix the overview, in the overview the user can go to settings to update any of his settings or setup done before and put three types of charts

and also ad a widget within the app to be added in the home screen to show the user overview

add haptics and sound feedback for each step and click and if mistake in name or somthing else with alert sound tone
the edit pin and +/- buttons do'snt work in the setup summary tab, fix this
include the sunrise check in the daily prayers so the user can click if he prayed it.
as the daily score changes, change the icon with the name and put some stars for scoring
in the weekly progress make the calculation real-time, i pressed sala of 3 times and no changes happened, untill i went to another tab and came back then the chart changed
in the daily verses, make it possible to go next or last verses with buttons lift and right of it
make the tabs icons colorful
in the qada tab put charts and supporting qouots
the hadith tab still empty not working and useless, fix this
in the azkar tab, allow user to rename, edit count target or delete
the azkar reminder also not working, i set a specific time yes but ddnt remind me or make any notification
and also user can make multiple reminders
the app starts without a pin, fix it
settings in the overiew tab not working says coming soon
also if i click the daily verses i should go to its location in the quran tab

at every time of a prayer, the application ask for the user status if prayed or not and in which mode or the user can select ask me later and the app asks him after 30minutes.
note also during the onboarding,  the user can selct not years missed but dayes, weeks, months or years so he can decide if he missed n days, n weeks, n months, n years and the application calculates based on the user input, fix that so give user 4 points of dayes> default 0, weeks the same, months the same, years the same and user put his info as he thinks.

in the azkars tab, even if the user added a reminder, it dosn't directly show on the screen, i need to move to another tab and come again so it can be seen, fix this and also when a user selects to delete a reminder, it says deleted but stayes in the list on the screen, fix that


i need also the prayers to be separated, the ones that are Fard and muslims must perform them (fajr, Dhuhr, Asr, Maghrib, Isha) in a one collection, and the Sonan or optional in another collection (Sunrise, Shafaa'a, Witr, etc)

don't take the exact names from me, review and check and get and set the correct and trusted names from a trusted source since im not a native english speaker


