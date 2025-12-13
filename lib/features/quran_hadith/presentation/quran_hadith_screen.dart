import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';

class QuranHadithScreen extends StatefulWidget {
  const QuranHadithScreen({super.key});

  @override
  State<QuranHadithScreen> createState() => _QuranHadithScreenState();
}

class _QuranHadithScreenState extends State<QuranHadithScreen> {
  int _totalVersesRead = 0;

  @override
  void initState() {
    super.initState();
    _loadTotalVersesRead();
  }

  Future<void> _loadTotalVersesRead() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalVersesRead = prefs.getInt('quran_total_verses_read') ?? 0;
    });
  }

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
              Tab(text: 'Hadith', icon: Icon(Icons.menu_book)),
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
    return Column(
      children: [
        // Total Verses Read Summary
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Total Verses Read: $_totalVersesRead',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: quran.totalSurahCount,
            itemBuilder: (context, index) {
              final surahNumber = index + 1;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
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
          ),
        ),
      ],
    );
  }

  void _openSurah(BuildContext context, int surahNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => _SurahDetailPage(
              surahNumber: surahNumber,
              onVersesReadChanged: () => _loadTotalVersesRead(),
            ),
      ),
    );
  }
}

class _SurahDetailPage extends StatefulWidget {
  final int surahNumber;
  final VoidCallback onVersesReadChanged;

  const _SurahDetailPage({
    required this.surahNumber,
    required this.onVersesReadChanged,
  });

  @override
  State<_SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<_SurahDetailPage> {
  Map<int, bool> _readStatus = {};

  @override
  void initState() {
    super.initState();
    _loadReadStatus();
  }

  Future<void> _loadReadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    Map<int, bool> status = {};
    for (int i = 1; i <= quran.getVerseCount(widget.surahNumber); i++) {
      status[i] = prefs.getBool('quran_read_${widget.surahNumber}_$i') ?? false;
    }
    setState(() => _readStatus = status);
  }

  Future<void> _toggleRead(int verseNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final currentStatus = _readStatus[verseNumber] ?? false;
    final newStatus = !currentStatus;

    await prefs.setBool(
      'quran_read_${widget.surahNumber}_$verseNumber',
      newStatus,
    );

    // Update total count
    int total = prefs.getInt('quran_total_verses_read') ?? 0;
    if (newStatus) {
      total++;
    } else {
      total--;
    }
    await prefs.setInt('quran_total_verses_read', total);

    setState(() => _readStatus[verseNumber] = newStatus);
    widget.onVersesReadChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quran.getSurahName(widget.surahNumber)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quran.getVerseCount(widget.surahNumber),
        itemBuilder: (context, index) {
          final verseNumber = index + 1;
          final isRead = _readStatus[verseNumber] ?? false;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isRead
                          ? Theme.of(
                            context,
                          ).colorScheme.secondaryContainer.withOpacity(0.5)
                          : Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      isRead ? Border.all(color: Colors.green, width: 2) : null,
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
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isRead
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isRead ? Colors.green : Colors.grey,
                          ),
                          onPressed: () => _toggleRead(verseNumber),
                          tooltip: isRead ? 'Mark as Unread' : 'Mark as Read',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      quran.getVerse(widget.surahNumber, verseNumber),
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
                        widget.surahNumber,
                        verseNumber,
                      ),
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    );
  }
}
