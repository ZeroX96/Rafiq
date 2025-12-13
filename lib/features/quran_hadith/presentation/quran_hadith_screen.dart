import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:quran/quran.dart' as quran;

class QuranHadithScreen extends StatefulWidget {
  const QuranHadithScreen({super.key});

  @override
  State<QuranHadithScreen> createState() => _QuranHadithScreenState();
}

class _QuranHadithScreenState extends State<QuranHadithScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quran & Hadith'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Quran', icon: Icon(FlutterIslamicIcons.quran)),
              Tab(
                text: 'Hadith',
                icon: Icon(Icons.menu_book),
              ), // Using standard icon for safety
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildQuranTab(),
            const Center(child: Text('Hadith Collections (Coming Soon)')),
          ],
        ),
      ),
    );
  }

  Widget _buildQuranTab() {
    return ListView.builder(
      itemCount: quran.totalSurahCount,
      itemBuilder: (context, index) {
        final surahNumber = index + 1;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              surahNumber.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          title: Text(
            quran.getSurahName(surahNumber),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            quran.getSurahNameEnglish(surahNumber),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Text(
            '${quran.getVerseCount(surahNumber)} Verses',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () => _openSurah(context, surahNumber),
        );
      },
    );
  }

  void _openSurah(BuildContext context, int surahNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: Text(quran.getSurahName(surahNumber)),
                centerTitle: true,
              ),
              body: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: quran.getVerseCount(surahNumber),
                itemBuilder: (context, index) {
                  final verseNumber = index + 1;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  child: Text(
                                    verseNumber.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              quran.getVerse(surahNumber, verseNumber),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 22,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              quran.getVerseTranslation(
                                surahNumber,
                                verseNumber,
                              ),
                              textAlign: TextAlign.left,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
      ),
    );
  }
}
