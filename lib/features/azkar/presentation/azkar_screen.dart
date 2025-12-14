import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<Map<String, dynamic>> _azkarList = [];
  Map<String, dynamic>? _selectedAzkar;
  int _lifetimeCount = 0;
  List<Map<String, dynamic>> _reminders = [];
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz_data.initializeTimeZones();
    _initNotifications();
    _loadAzkar();
    _loadReminders();
  }

  Future<void> _initNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initSettings);

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> _loadAzkar() async {
    final prefs = await SharedPreferences.getInstance();
    final azkarJson = prefs.getString('azkar_list');

    if (azkarJson != null) {
      _azkarList = List<Map<String, dynamic>>.from(json.decode(azkarJson));
    } else {
      // Default Azkar
      _azkarList = [
        {'id': 1, 'content': 'Subhan Allah', 'target': 33, 'count': 0},
        {'id': 2, 'content': 'Alhamdulillah', 'target': 33, 'count': 0},
        {'id': 3, 'content': 'Allahu Akbar', 'target': 34, 'count': 0},
        {'id': 4, 'content': 'Astaghfirullah', 'target': 100, 'count': 0},
        {'id': 5, 'content': 'La ilaha illallah', 'target': 100, 'count': 0},
      ];
    }

    for (var azkar in _azkarList) {
      azkar['count'] = prefs.getInt('azkar_${azkar['id']}') ?? 0;
    }
    _lifetimeCount = prefs.getInt('azkar_lifetime_total') ?? 0;
    setState(() {});
  }

  Future<void> _saveAzkarList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('azkar_list', json.encode(_azkarList));
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

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson = prefs.getString('azkar_reminders');
    if (remindersJson != null) {
      _reminders = List<Map<String, dynamic>>.from(json.decode(remindersJson));
    }
    setState(() {});
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('azkar_reminders', json.encode(_reminders));
  }

  Future<void> _addReminder(TimeOfDay time) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    _reminders.add({'id': id, 'hour': time.hour, 'minute': time.minute});
    await _saveReminders();
    await _scheduleReminder(id, time);
    setState(() {});
  }

  Future<void> _deleteReminder(int id) async {
    await _notificationsPlugin.cancel(id);
    _reminders.removeWhere((r) => r['id'] == id);
    await _saveReminders();
    setState(() {});
  }

  Future<void> _scheduleReminder(int id, TimeOfDay time) async {
    const androidDetails = AndroidNotificationDetails(
      'azkar_channel',
      'Azkar Reminders',
      channelDescription: 'Reminders to do Azkar',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
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

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        'Azkar Reminder',
        'It\'s time for your Azkar!',
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      // Fallback: show immediate notification if scheduling fails
      await _notificationsPlugin.show(
        id,
        'Azkar Reminder Set',
        'You will be reminded at ${time.format(context)}',
        details,
      );
    }
  }

  void _showAddReminderDialog() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Set Reminder Time',
    );
    if (time != null) {
      await _addReminder(time);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder set for ${time.format(context)}')),
        );
      }
    }
  }

  void _addAzkar(String content, int target) {
    HapticFeedback.mediumImpact();
    setState(() {
      _azkarList.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'content': content,
        'target': target,
        'count': 0,
      });
    });
    _saveAzkarList();
  }

  void _editAzkar(int id, String content, int target) {
    HapticFeedback.lightImpact();
    final index = _azkarList.indexWhere((a) => a['id'] == id);
    if (index != -1) {
      setState(() {
        _azkarList[index]['content'] = content;
        _azkarList[index]['target'] = target;
      });
      _saveAzkarList();
    }
  }

  void _deleteAzkar(int id) {
    HapticFeedback.heavyImpact();
    setState(() => _azkarList.removeWhere((a) => a['id'] == id));
    _saveAzkarList();
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
              setState(() => _selectedAzkar!['count'] = count);
              _saveAzkarCount(_selectedAzkar!['id'], count);
              _incrementLifetimeCount();
            },
            onTargetReached: () {
              HapticFeedback.heavyImpact();
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
            onPressed: _showAddReminderDialog,
            tooltip: 'Add Reminder',
          ),
        ],
      ),
      body: Column(
        children: [
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
                  'Lifetime Azkar: $_lifetimeCount',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (_reminders.isNotEmpty) _buildRemindersList(),
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
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') _showEditDialog(item);
                        if (value == 'delete') _deleteAzkar(item['id']);
                      },
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                    ),
                    onTap: () => setState(() => _selectedAzkar = item),
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

  Widget _buildRemindersList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Reminders',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                _reminders.map((r) {
                  final time = TimeOfDay(hour: r['hour'], minute: r['minute']);
                  return InputChip(
                    label: Text(time.format(context)),
                    deleteIcon: const Icon(Icons.close, size: 20),
                    onDeleted: () {
                      _deleteReminder(r['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reminder deleted'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    onPressed: () => _showEditReminderDialog(r),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  void _showEditReminderDialog(Map<String, dynamic> reminder) async {
    final initialTime = TimeOfDay(
      hour: reminder['hour'],
      minute: reminder['minute'],
    );
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: 'Edit Reminder Time',
    );
    if (time != null) {
      await _deleteReminder(reminder['id']);
      await _addReminder(time);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder updated to ${time.format(context)}'),
          ),
        );
      }
    }
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

  void _showEditDialog(Map<String, dynamic> item) {
    final contentController = TextEditingController(text: item['content']);
    final targetController = TextEditingController(
      text: item['target'].toString(),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Azkar'),
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
                  _editAzkar(
                    item['id'],
                    contentController.text,
                    int.tryParse(targetController.text) ?? 33,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}
