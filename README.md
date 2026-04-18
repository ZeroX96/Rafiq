# 🕌 Rafiq (رفيق)
### *Your Companion to Heaven - رفيقك إلى الجنة*

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg?style=for-the-badge)](https://opensource.org/licenses/Apache-2.0)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge)](http://makeapullrequest.com)

![Rafiq Cover](assets/images/rafiq_project_cover.png)

**Rafiq** is a comprehensive, privacy-first spiritual companion for Muslims. It is designed to help you stay consistent with your daily prayers, recover missed prayers (**Qada**), track your progress in reading the **Quran** and **Hadith**, and maintain your daily **Azkar**. 

Our mission is to provide a supportive, non-judgmental, and secure environment to help you strengthen your relationship with Allah (SWT).

---

## 🌟 Core Features

### 📅 Prayer Tracking
- **Smart Logging**: Manual check-in for five daily prayers with on-time and late status.
- **Dynamic Scoring**: Build your discipline and watch your spiritual rank grow from *Muslim* to *Siddiq*.
- **Visual Progress**: Daily and weekly charts to visualize your consistency and adherence.
- **Sunnah Support**: Track optional prayers (Sunrise, Shafaa, Witr) to go above and beyond.

### 📉 Qada (Missed Prayer) Recovery
- **Intelligent Calculator**: Establishes your "debt" based on age, puberty, and missed years/months/days.
- **Debt Visualization**: View your progress in clearing your missed prayers with manageable milestones.
- **Smart Planning**: (Upcoming) Personalized plans to clear your debt alongside your current prayers.
- **Repentance Focus**: Encouraging messages focused on Allah's mercy rather than the burden of debt.

### 📖 Quran & Hadith
- **In-App Reader**: Read the Quran verse-by-verse with progress tracking.
- **Deep Linking**: Click a "Verse of the Day" and go straight to its location in the Quran.
- **Authentic Hadith**: Access collections like the *Forty Hadith an-Nawawi* for daily learning.
- **Reading Logs**: Track how many verses you've read across your entire spiritual journey.

### 📿 Azkar & Reminders
- **Digital Tasbih**: Customizable counters for your favorite Azkar.
- **Smart Reminders**: Set multiple notifications for morning, evening, or specific times of need.
- **Lifetime Counts**: See the cumulative energy of your Dhikr over years of use.

---

## 🛡️ Security & Privacy First

We understand that spiritual progress is deeply personal. Rafiq is built with a **Privacy-First** architecture:

- **Offline-First**: Your data never leaves your device by default. No cloud sync unless you explicitly enable it.
- **Encrypted Local Storage**: Sensitive logs are stored using **Drift (SQLite)** with **SQLCipher** for on-device encryption.
- **App Lock**: Optional PIN protection and Biometric authentication to keep your progress private.
- **No Third-Party Tracking**: We don't sell your data or use intrusive analytics.

---

## 🛠️ Technical Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: [Riverpod](https://riverpod.dev)
- **Database**: [Drift](https://drift.simonbinder.eu/) (SQLite)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Visuals**: [FL Chart](https://pub.dev/packages/fl_chart)
- **Spiritual Logic**: [Adhan](https://pub.dev/packages/adhan) (Prayer times), [Quran](https://pub.dev/packages/quran)

---

## 🚀 Getting Started

1. **Prerequisites**: Ensure you have [Flutter](https://docs.flutter.dev/get-started/install) installed.
2. **Clone the Repo**:
   ```bash
   git clone https://github.com/your-username/rafiq.git
   cd rafiq
   ```
3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the App**:
   ```bash
   flutter run
   ```

---

## 🤝 Joining the Efforts

We are looking for dedicated individuals to help us build the ultimate spiritual companion. You can contribute in several ways:

### 💻 Development
- **Feature Enhancement**: Helping implement the "Remaining Features" listed in our [App Feature List](App%20Feature%20List.md).
- **UI/UX Refinement**: Improving responsiveness and adding more delightful animations.
- **Bug Hunting**: Identifying and fixing issues in the core tracking logic.

### 🔒 Security & Privacy
- **Code Auditing**: Reviewing our encryption implementation and local data handling.
- **Privacy Policy**: Drafting and maintaining a transparent privacy policy for users.

### 🧪 Testing
- **Beta Testing**: Testing the app on various Android/iOS devices to ensure stability.
- **Unit & UI Tests**: Writing automated tests to ensure core logic (like Qada calculation) is 100% accurate.

### 🕌 Spiritual Accuracy
- **Scholar Review**: If you are a student of knowledge or a scholar, help us review the religious guidance and messaging tone.
- **Quran/Hadith Data**: Ensuring the accuracy of translations and source texts.

---

## 🗺️ Roadmap

- [ ] **Arabic Localization**: Full support for Arabic language and RTL layout.
- [ ] **Audio Quran**: Integration of various reciters for verse-by-verse playback.
- [ ] **Community Features**: Opt-in anonymous groups and "Buddy Support" for accountability.
- [ ] **Cloud Backup**: Optional encrypted backup via Google Drive/iCloud.

---

## 📜 License

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.

---

## 📬 Contact & Support

If you have questions, ideas, or want to join the team:
- **Email**: [Mahmoud.S.Abdelhares@Gmail.com]
- **GitHub Discussions**: [Join the conversation here]

> **"The first thing for which a servant will be brought to account on the Day of Resurrection will be his prayer..."** — *Hadith*
