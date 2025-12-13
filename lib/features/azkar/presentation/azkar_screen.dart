import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rafiq/features/azkar/presentation/azkar_counter_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

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
  int _lifetimeCount = 0;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadAzkar();
    _initNotifications();
    tz_data.initializeTimeZones();
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
      _lifetimeCount = prefs.getInt('azkar_lifetime_total') ?? 0;
    });
  }

  Future<void> _saveAzkarCount(int id, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('azkar_$id', count);
  }

  Future<void> _incrementLifetimeCount() async {
    final prefs = await SharedPreferences.getInstance();
    _lifetimeCount++;
    await prefs.setInt('azkar_lifetime_total', _lifetimeCount);
    setState(() {});
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

  Future<void> _scheduleReminderAtTime(TimeOfDay time) async {
    const androidDetails = AndroidNotificationDetails(
      'azkar_channel',
      'Azkar Reminders',
      channelDescription: 'Reminders to do Azkar',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      time.hour * 60 + time.minute, // Unique ID based on time
      'Azkar Reminder',
      'It\'s time for your Azkar!',
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Repeats daily
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder set for ${time.format(context)} daily!'),
        ),
      );
    }
  }

  void _showTimePickerDialog() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Select Reminder Time',
    );
    if (time != null) {
      await _scheduleReminderAtTime(time);
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
              _incrementLifetimeCount();
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
            icon: const Icon(Icons.alarm_add),
            onPressed: _showTimePickerDialog,
            tooltip: 'Set Specific Reminder',
          ),
        ],
      ),
      body: Column(
        children: [
          // Lifetime Counter Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FlutterIslamicIcons.solidMosque,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Lifetime Azkar Count: $_lifetimeCount',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _azkarList.length,
              itemBuilder: (context, index) {
                final item = _azkarList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
          ),
        ],
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
