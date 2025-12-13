import 'package:flutter/material.dart';
import 'package:rafiq/features/quran_hadith/data/quran_data_source.dart';

class QuranHadithScreen extends StatefulWidget {
  const QuranHadithScreen({super.key});

  @override
  State<QuranHadithScreen> createState() => _QuranHadithScreenState();
}

class _QuranHadithScreenState extends State<QuranHadithScreen> {
  final QuranDataSource _dataSource = QuranDataSource();
  List<dynamic> _surahs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _dataSource.loadQuran();
    setState(() {
      _surahs = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quran & Hadith'),
          bottom: const TabBar(tabs: [Tab(text: 'Quran'), Tab(text: 'Hadith')]),
        ),
        body: TabBarView(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: _surahs.length,
                  itemBuilder: (context, index) {
                    final surah = _surahs[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(surah['id'].toString()),
                      ),
                      title: Text(surah['name']),
                      subtitle: Text(surah['translation']),
                      trailing: Text(surah['type']),
                      onTap: () {
                        // Navigate to detail (placeholder for now)
                        showModalBottomSheet(
                          context: context,
                          builder:
                              (context) => Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surah['name'],
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.headlineSmall,
                                    ),
                                    const Divider(),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: surah['verses'].length,
                                        itemBuilder: (context, vIndex) {
                                          final verse = surah['verses'][vIndex];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  verse['text'],
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Amiri',
                                                  ), // Assuming font
                                                  textAlign: TextAlign.right,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  verse['translation'],
                                                  textAlign: TextAlign.left,
                                                  style:
                                                      Theme.of(
                                                        context,
                                                      ).textTheme.bodyMedium,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
                    );
                  },
                ),
            const Center(child: Text('Hadith Collections (Coming Soon)')),
          ],
        ),
      ),
    );
  }
}
