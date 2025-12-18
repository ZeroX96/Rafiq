# Rafiq - Remaining Features

> **Last Updated**: December 18, 2025  
> **Status**: Planned for Future Releases

---

## 1. Prayer Notifications System

### 1.1 Auto-Scheduling Prayer Notifications
- Schedule notifications at each prayer time automatically
- Use Adhan library calculated times
- Reschedule daily at midnight

### 1.2 Interactive Actions
| Action | Result |
|--------|--------|
| "Prayed" | Mark prayer as Fard, dismiss notification |
| "Remind Later" | Reschedule for 30 minutes (implemented) |

### 1.3 Pre-Prayer Reminders
- Configurable: 5/10/15/30 minutes before
- Per-prayer customization
- Settings toggle

### 1.4 Post-Prayer Check
- 30 minutes after prayer time
- "Did you pray?" notification
- Links to prayer marking screen

---

## 2. Qada Smart Plan

### 2.1 Debt Clearance Calculator
```
Daily Qada = Total Debt / (Target Months × 30)
```

### 2.2 Suggested Plans
| Plan | Daily Qada | Monthly Progress |
|------|------------|------------------|
| Basic | 1 after each Fard | 150 prayers/month |
| Moderate | 2 after each Fard | 300 prayers/month |
| Intensive | 3 after each Fard | 450 prayers/month |

### 2.3 Progress Tracking
- Daily Qada counter (resets at midnight)
- Streak tracking
- Goal completion projection

---

## 3. Enhanced Quran Features

### 3.1 Audio Recitation
- Multiple reciters (Alafasy, Minshawi, Husary)
- Per-verse playback
- Continuous surah playback
- API: api.alquran.cloud

### 3.2 Translations
- English (Sahih International)
- Urdu, Turkish, Indonesian, French
- Toggle Arabic/Translation view

### 3.3 Bookmarking
- Bookmark any verse
- Add notes
- Color categories (Study, Favorite, Memorize)
- Last-read position

### 3.4 Juz Navigation
- 30 Juz picker
- Juz progress indicator

---

## 4. Community Features

### 4.1 Anonymous Prayer Groups
- Create/join groups with invite code
- See collective prayer count
- Group challenges

### 4.2 Friend Connections
- Share progress with trusted friends
- Configurable privacy (what to share)
- Send encouragement messages

### 4.3 Dua Requests
- Post anonymous dua requests
- "I prayed for you" counter
- Categories (Health, Family, Work)

---

## 5. Notifications Enhancement

### 5.1 Escalating Intensity
| Missed Count | Intensity | Example |
|--------------|-----------|---------|
| 0 | Gentle | "Time for Fajr" |
| 1-2 | Moderate | "Don't miss Fajr! Prayer is the pillar..." |
| 3+ | Urgent | "⚠️ You've missed prayers..." |

### 5.2 Weekly Summary (Fridays)
- Prayers completed vs missed
- Qada progress
- Azkar count
- Current streak

---

## 6. Cloud Sync & Backup

### 6.1 Firebase Integration
- Firestore for data storage
- Real-time sync across devices

### 6.2 Authentication Options
- Google Sign-In
- Apple Sign-In
- Email/Password

### 6.3 Export Options
- JSON backup
- PDF report
- CSV spreadsheet

---

## Implementation Priority

| Priority | Feature | Effort |
|----------|---------|--------|
| 🔴 P1 | Prayer Notifications | Medium |
| 🔴 P1 | Qada Smart Plan | Low |
| 🟡 P2 | Quran Audio | Medium |
| 🟡 P2 | Cloud Backup | High |
| 🟢 P3 | Community | High |
| 🟢 P3 | Escalating Notifications | Medium |

---

*End of Remaining Features*
