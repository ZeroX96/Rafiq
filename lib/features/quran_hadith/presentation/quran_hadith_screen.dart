import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuranHadithScreen extends StatefulWidget {
  const QuranHadithScreen({super.key});

  @override
  State<QuranHadithScreen> createState() => _QuranHadithScreenState();
}

class _QuranHadithScreenState extends State<QuranHadithScreen> {
  int _totalVersesRead = 0;

  // Static Hadith Collection (Forty Hadith an-Nawawi)
  final List<Map<String, String>> _hadithList = [
    {
      'number': '1',
      'title': 'Actions are by Intentions',
      'text':
          'Actions are but by intentions, and every person will have only what they intended...',
      'source': 'Bukhari & Muslim',
    },
    {
      'number': '2',
      'title': 'Hadith of Jibreel',
      'text':
          'Inform me about Islam. He said: Islam is to testify that there is no deity worthy of worship except Allah...',
      'source': 'Muslim',
    },
    {
      'number': '3',
      'title': 'Pillars of Islam',
      'text':
          'Islam is built upon five: testimony that there is no god but Allah, establishing prayer, giving zakat...',
      'source': 'Bukhari & Muslim',
    },
    {
      'number': '4',
      'title': 'Creation in the Womb',
      'text':
          'Each one of you is constituted in the womb of the mother for forty days...',
      'source': 'Bukhari & Muslim',
    },
    {
      'number': '5',
      'title': 'Rejected Deeds',
      'text':
          'Whoever introduces into this affair of ours that which is not from it, it is rejected.',
      'source': 'Bukhari & Muslim',
    },
    {
      'number': '6',
      'title': 'Halal and Haram',
      'text':
          'The halal is clear and the haram is clear, and between them are matters unclear...',
      'source': 'Bukhari & Muslim',
    },
    {
      'number': '7',
      'title': 'Religion is Sincerity',
      'text':
          'The religion is sincerity. We said: To whom? He said: To Allah, His Book, His Messenger, the leaders of the Muslims and their common folk.',
      'source': 'Muslim',
    },
    {
      'number': '8',
      'title': 'Sanctity of a Muslim',
      'text':
          'I have been ordered to fight against the people until they testify that there is no deity worthy of worship except Allah...',
      'source': 'Bukhari & Muslim',
    },
    {
      'number': '9',
      'title': 'Obligations',
      'text':
          'What I have forbidden you from, avoid it. And what I have commanded you to do, do as much of it as you can...',
      'source': 'Bukhari & Muslim',
    },
    {
      'number': '10',
      'title': 'Pure Earnings',
      'text': 'Allah is pure and accepts only that which is pure...',
      'source': 'Muslim',
    },
    {
      'number': '11',
      'title': 'Leaving Doubtful Matters',
      'text':
          'Leave that which makes you doubt for that which does not make you doubt.',
      'source': 'Tirmidhi & Nasa\'i',
    },
    {
      'number': '12',
      'title': 'Leave What Does Not Concern You',
      'text':
          'Part of the perfection of one\'s Islam is leaving that which does not concern him.',
      'source': 'Tirmidhi',
    },
    {
      'number': '13',
      'title': 'None of You Believes',
      'text':
          'None of you truly believes until he loves for his brother what he loves for himself.',
      'source': 'Bukhari & Muslim',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadTotalVersesRead();
  }

  Future<void> _loadTotalVersesRead() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () => _totalVersesRead = prefs.getInt('quran_total_verses_read') ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quran & Hadith'),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(
                text: 'Quran',
                icon: Icon(FlutterIslamicIcons.quran, color: Colors.green),
              ),
              Tab(
                text: 'Hadith',
                icon: Icon(Icons.menu_book, color: Colors.amber),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [_buildQuranTab(), _buildHadithTab()]),
      ),
    );
  }

  Widget _buildQuranTab() {
    return Column(
      children: [
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

  Widget _buildHadithTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _hadithList.length,
      itemBuilder: (context, index) {
        final hadith = _hadithList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(
                hadith['number']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              hadith['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              hadith['source']!,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  hadith['text']!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openSurah(BuildContext context, int surahNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SurahDetailScreen(
              surahNumber: surahNumber,
              onVersesReadChanged: () => _loadTotalVersesRead(),
            ),
      ),
    );
  }
}

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final int? initialVerse;
  final VoidCallback? onVersesReadChanged;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    this.initialVerse,
    this.onVersesReadChanged,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  Map<int, bool> _readStatus = {};

  @override
  void initState() {
    super.initState();
    _loadReadStatus();
    if (widget.initialVerse != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToVerse(widget.initialVerse!);
      });
    }
  }

  void _scrollToVerse(int verse) {
    if (verse > 0) {
      _itemScrollController.jumpTo(index: verse - 1);
    }
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
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    final currentStatus = _readStatus[verseNumber] ?? false;
    final newStatus = !currentStatus;

    await prefs.setBool(
      'quran_read_${widget.surahNumber}_$verseNumber',
      newStatus,
    );

    int total = prefs.getInt('quran_total_verses_read') ?? 0;
    if (newStatus)
      total++;
    else
      total--;
    await prefs.setInt('quran_total_verses_read', total);

    setState(() => _readStatus[verseNumber] = newStatus);
    if (widget.onVersesReadChanged != null) {
      widget.onVersesReadChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quran.getSurahName(widget.surahNumber)),
        centerTitle: true,
      ),
      body: ScrollablePositionedList.builder(
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
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
