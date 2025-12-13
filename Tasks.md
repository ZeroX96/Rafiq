Rafiq App Development Task List
Planning Phase
 Review requirements and feature list
 Update Implementation Plan (Offline & Skip Qada)
 Generate 30 Clarification Questions
 User Review of Plan and Questions
 Project Setup
 Initialize Flutter Project
 Setup Project Structure (MVVM/Clean Arch)
 Setup Dependencies (riverpod, drift, local_auth, etc.)
 Setup Assets (Fonts, Icons, JSONs)
 Core Features Implementation (Offline MVP)
 Database Schema Design (Drift)
Security & Settings
 PIN/Biometric Lock (local_auth)
 Data Export (CSV/JSON)
 Tab 1: Daily Prayer Tracking
 Location Selection (Local DB)
 Prayer Times Logic (Configurable)
 Notifications (System + Pre-notify)
 UI Implementation
 Tab 2: Debt/Qada Tracking
 Calculator Logic (Lunar Years)
 Auto-increment Logic (Background/Daily)
 UI Implementation
 Tab 3: Quran & Hadith
 JSON Data Loading (Uthmani/Sahih)
 Reader UI & Bookmarking
 Audio Downloader Logic
 Tab 4: Azkar
 Counter UI (Sound/Vibration)
 Custom Azkar & Rewards CRUD
 Tab 5: User Overview
 Statistics Calculation (Streaks)
 Charts/Graphs UI
 Verification & Polish
 Manual Testing of all flows (Build Verified)
 UI/UX Polish (Green/Gold Theme)
 Build Release APK
 Revamp Onboarding (Multi-step Wizard)
 Implement Debt Calculation Logic in Onboarding
 Fix Redirect Logic
 Daily Prayer Gamification
 Fix Daily Score Logic (Dynamic)
 Fix Weekly Progress Chart
 Add Shafaa and Witr Prayers
 Qada Tab Enhancements
 UI: Make prayer area a large button for "Mark Done"
 Keep "+" button for corrections
 Add "Hide Debt" Option
 Add Motivational/Warning Text
 Quran Content
 Fix Data Display (Use Package/API)
 Add "Mark Verse as Read" Feature
 Track Total Verses Read in Overview
 Azkar Fixes
 Add Overall/Lifetime Counter
 Fix Reminder Button (Specific Time Picker)
 Onboarding Overhaul
 Validation: Name (Alphabets only), Email (Gmail regex)
 Navigation: Fix Back/Enter buttons
 Content: Add Quran/Hadith/Quotes to all steps
 Logic: Add Menstruation Duration for Debt Calc
 Logic: Allow Debt Correction in Summary
 Overview Tab Revamp
 Show Real Data (Prayers, Quran, Azkar, Debt)
 Add 3 Types of Charts
 Add Settings Access
 Home Screen Widget
 Implement Android Home Screen Widget
 UI Polish
 Switch to Muslim-themed Icons
 Add Quran Verse/Text to All Screens

 Rafiq App Development Task List - Phase 3
 Previous Phases (Onboarding, Gamification, Qada, Quran, Azkar, Overview)
 Phase 3: Bug Fixes & Enhancements
 Haptics & Sound Feedback
 Add haptic feedback on button taps
 Add sound for steps/clicks
 Add alert sound for validation errors
 Onboarding Fixes
 Fix +/- buttons in Summary step
 Fix Edit PIN button (not working)
 Daily Prayer
 Include Sunrise as checkable prayer
 Change icon/stars based on score
 Real-time weekly chart update (no tab switch needed)
 Daily Verse: Add prev/next buttons
 Daily Verse: Click navigates to Quran tab location
 Tab Icons
 Make nav bar icons colorful
 Qada Tab
 Add charts (progress visualization)
 Add supporting Quran/Hadith quotes
 Hadith Tab
 Implement actual Hadith content (API or bundled JSON)
 Azkar Tab
 Allow rename/edit target/delete
 Fix reminder notifications (not triggering)
 Allow multiple reminders
 PIN Lock
 App should start with PIN prompt
 Settings
 Make Overview Settings button functional