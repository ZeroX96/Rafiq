import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rafiq/features/azkar/presentation/azkar_counter_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  List<Map<String, dynamic>> _azkarList = [
    {'id': 1, 'content': 'Subhan Allah', 'target': 33, 'count': 0},
    {'id': 2, 'content': 'Alhamdulillah', 'target': 33, 'count': 0},
    {'id': 3, 'content': 'Allahu Akbar', 'target': 34, 'count': 0},
    {'id': 4, 'content': 'Astaghfirullah', 'target': 100, 'count': 0},
  ];

  Map<String, dynamic>? _selectedAzkar;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadAzkar();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> _loadAzkar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var azkar in _azkarList) {
        azkar['count'] = prefs.getInt('azkar_${azkar['id']}') ?? 0;
      }
    });
  }

  Future<void> _saveAzkarCount(int id, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('azkar_$id', count);
  }

  Future<void> _addAzkar(String content, int target) async {
    setState(() {
      _azkarList.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'content': content,
        'target': target,
        'count': 0,
      });
    });
  }

  Future<void> _scheduleReminder() async {
    const androidDetails = AndroidNotificationDetails(
      'azkar_channel',
      'Azkar Reminders',
      channelDescription: 'Reminders to do Azkar after prayers',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    // Schedule for 15 minutes from now (Demo)
    await _notificationsPlugin.show(
      0,
      'Azkar Reminder',
      'Don\'t forget your Azkar!',
      details,
    );

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reminder scheduled!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedAzkar != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _selectedAzkar = null),
          ),
          title: Text(_selectedAzkar!['content']),
        ),
        body: Center(
          child: AzkarCounterWidget(
            target: _selectedAzkar!['target'],
            initialCount: _selectedAzkar!['count'],
            onCountChanged: (count) {
              setState(() {
                _selectedAzkar!['count'] = count;
              });
              _saveAzkarCount(_selectedAzkar!['id'], count);
            },
            onTargetReached: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Target Reached! MashaAllah!')),
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Azkar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: _scheduleReminder,
            tooltip: 'Schedule Reminder',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _azkarList.length,
        itemBuilder: (context, index) {
          final item = _azkarList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                FlutterIslamicIcons.solidMosque,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                item['content'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Target: ${item['target']} • Current: ${item['count']}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _selectedAzkar = item;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    final contentController = TextEditingController();
    final targetController = TextEditingController(text: '33');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Azkar'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: 'Azkar Content'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: targetController,
                  decoration: const InputDecoration(labelText: 'Target Count'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (contentController.text.isNotEmpty) {
                    _addAzkar(
                      contentController.text,
                      int.tryParse(targetController.text) ?? 33,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}
