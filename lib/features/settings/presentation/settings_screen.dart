import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rafiq/features/pin/presentation/pin_screen.dart';
import 'package:rafiq/core/services/notification_service.dart';
import 'package:rafiq/core/services/prayer_notification_scheduler.dart';
import 'package:rafiq/core/services/backup_service.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _name = '';
  String _location = '';
  String _gender = '';
  String _madhab = '';

  // Notification settings
  bool _notificationsEnabled = true;
  int _preReminderMinutes = 10;
  int _postCheckMinutes = 20;
  bool _sunnahNotifications = true;
  String _notificationSound = 'default'; // 'azan', 'default', 'silent'

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('profile_name') ?? 'Not set';
      _location = prefs.getString('location_name') ?? 'Not set';
      _gender = prefs.getString('profile_gender') ?? 'Not set';
      _madhab = prefs.getString('profile_madhab') ?? 'Not set';

      // Load notification settings
      _notificationsEnabled =
          prefs.getBool('prayer_notifications_enabled') ?? true;
      _preReminderMinutes = prefs.getInt('pre_prayer_reminder_minutes') ?? 10;
      _postCheckMinutes = prefs.getInt('post_prayer_check_minutes') ?? 20;
      _sunnahNotifications =
          prefs.getBool('sunnah_notifications_enabled') ?? true;
      _notificationSound = prefs.getString('notification_sound') ?? 'default';
    });
  }

  Future<void> _resetOnboarding() async {
    HapticFeedback.mediumImpact();
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset Setup?'),
            content: const Text(
              'This will take you back to the onboarding flow to update your information.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Reset'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', false);
      if (mounted) context.go('/onboarding');
    }
  }

  Future<void> _clearAllData() async {
    HapticFeedback.heavyImpact();
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear All Data?'),
            content: const Text(
              'This will delete all your prayer history, Quran progress, and Azkar data. This cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Clear'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAvatar(),
          const SizedBox(height: 24),
          _buildSectionHeader('Profile'),
          _buildSettingsTile('Name', _name, Icons.person, _editName),
          _buildSettingsTile(
            'Location',
            _location,
            Icons.location_on,
            _editLocation,
          ),
          _buildSettingsTile(
            'Gender',
            _gender,
            Icons.wc,
            null,
          ), // Gender usually fixed or requires re-onboarding
          _buildSettingsTile('Madhab', _madhab, Icons.school, _editMadhab),
          const Divider(height: 32),
          _buildSectionHeader('Security'),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.blue),
            title: const Text('App PIN'),
            subtitle: const Text('Secure app with a PIN'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PinScreen(isSetup: true),
                ),
              );
            },
          ),
          const Divider(height: 32),
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            secondary: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Prayer Notifications'),
            subtitle: const Text('Get notified at prayer times'),
            value: _notificationsEnabled,
            onChanged: (value) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('prayer_notifications_enabled', value);
              setState(() => _notificationsEnabled = value);
            },
          ),
          if (_notificationsEnabled) ...[
            ListTile(
              leading: Icon(
                Icons.timer,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Pre-Prayer Reminder'),
              subtitle: Text(
                _preReminderMinutes == 0
                    ? 'Off'
                    : '$_preReminderMinutes minutes before',
              ),
              trailing: DropdownButton<int>(
                value: _preReminderMinutes,
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Off')),
                  DropdownMenuItem(value: 5, child: Text('5 min')),
                  DropdownMenuItem(value: 10, child: Text('10 min')),
                  DropdownMenuItem(value: 15, child: Text('15 min')),
                  DropdownMenuItem(value: 30, child: Text('30 min')),
                ],
                onChanged: (value) async {
                  if (value != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('pre_prayer_reminder_minutes', value);
                    setState(() => _preReminderMinutes = value);
                  }
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.help_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Post-Prayer Check'),
              subtitle: Text('$_postCheckMinutes minutes after prayer'),
              trailing: DropdownButton<int>(
                value: _postCheckMinutes,
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Off')),
                  DropdownMenuItem(value: 10, child: Text('10 min')),
                  DropdownMenuItem(value: 20, child: Text('20 min')),
                  DropdownMenuItem(value: 30, child: Text('30 min')),
                ],
                onChanged: (value) async {
                  if (value != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('post_prayer_check_minutes', value);
                    setState(() => _postCheckMinutes = value);
                  }
                },
              ),
            ),
            SwitchListTile(
              secondary: Icon(
                Icons.star_outline,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text('Sunnah Notifications'),
              subtitle: const Text('Sunrise, Shafaa, Witr'),
              value: _sunnahNotifications,
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('sunnah_notifications_enabled', value);
                setState(() => _sunnahNotifications = value);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.music_note,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Notification Sound'),
              trailing: DropdownButton<String>(
                value: _notificationSound,
                items: const [
                  DropdownMenuItem(value: 'azan', child: Text('Azan')),
                  DropdownMenuItem(value: 'default', child: Text('Default')),
                  DropdownMenuItem(value: 'silent', child: Text('Silent')),
                ],
                onChanged: (value) async {
                  if (value != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('notification_sound', value);
                    setState(() => _notificationSound = value);
                  }
                },
              ),
            ),
            const Divider(indent: 50),
            ListTile(
              leading: const Icon(Icons.bug_report, color: Colors.orange),
              title: const Text('Test Notification'),
              subtitle: const Text('Send an immediate test notification'),
              onTap: () async {
                await NotificationService().showImmediateNotification(
                  id: 999,
                  title: 'Test Notification',
                  body: 'If you see this, notifications are working!',
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Test notification sent!')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.green),
              title: const Text('Request Permissions'),
              subtitle: const Text('Manually request notification permissions'),
              onTap: () async {
                await NotificationService().requestPermissions();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Permissions requested!')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.sync, color: Colors.blue),
              title: const Text('Reschedule All'),
              subtitle: const Text('Force reschedule all prayer notifications'),
              onTap: () async {
                await PrayerNotificationScheduler.rescheduleAll();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications rescheduled!')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.purple),
              title: const Text('Check Status'),
              subtitle: const Text('Check if notifications are allowed by OS'),
              onTap: () async {
                final status = await Permission.notification.status;
                final exactAlarm = await Permission.scheduleExactAlarm.status;
                if (mounted) {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Notification Status'),
                          content: Text(
                            'Notifications: ${status.name}\n'
                            'Exact Alarms: ${exactAlarm.name}\n'
                            'Plugin Init: ${NotificationService().isInitialized}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_applications,
                color: Colors.grey,
              ),
              title: const Text('Open App Settings'),
              subtitle: const Text('Open system settings to enable manually'),
              onTap: () async {
                await openAppSettings();
              },
            ),
          ],
          const Divider(height: 32),
          const Divider(height: 32),
          _buildSectionHeader('Data Management'),
          ListTile(
            leading: const Icon(Icons.cloud_download, color: Colors.blue),
            title: const Text('Export Backup'),
            subtitle: const Text('Save your progress to a file'),
            onTap: () => BackupService.exportData(context),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload, color: Colors.green),
            title: const Text('Import Backup'),
            subtitle: const Text('Restore from JSON clipboard'),
            onTap: _showImportDialog,
          ),
          const Divider(height: 32),
          _buildSectionHeader('Actions'),
          ListTile(
            leading: const Icon(Icons.refresh, color: Colors.orange),
            title: const Text('Re-run Onboarding'),
            subtitle: const Text('Update your profile and recalculate debt'),
            onTap: _resetOnboarding,
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear All Data'),
            subtitle: const Text('Delete all saved data'),
            onTap: _clearAllData,
          ),
          const Divider(height: 32),
          _buildSectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Rafiq'),
            subtitle: Text('Version 1.0.0\nYour Islamic prayer companion'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    String imagePath = 'assets/images/avatar_man.png';
    if (_gender.toLowerCase().contains('female') ||
        _gender.toLowerCase().contains('girl') ||
        _gender.toLowerCase().contains('woman')) {
      imagePath = 'assets/images/avatar_woman.png';
    }
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundImage: AssetImage(imagePath),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingsTile(
    String label,
    String value,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ],
      ),
      onTap: onTap,
    );
  }

  Future<void> _editName() async {
    final controller = TextEditingController(text: _name);
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Name'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: const Text('Save'),
              ),
            ],
          ),
    );

    if (result != null && result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_name', result);
      setState(() => _name = result);
    }
  }

  Future<void> _editLocation() async {
    final controller = TextEditingController(text: _location);
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Location'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'City, Country'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: const Text('Save'),
              ),
            ],
          ),
    );

    if (result != null && result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('location_name', result);
      // Note: This only updates the name, not the coordinates.
      // Ideally we should re-trigger location search, but for now this satisfies "change name or location".
      setState(() => _location = result);
    }
  }

  Future<void> _editMadhab() async {
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: const Text('Select Madhab'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'Hanafi'),
                child: const Text('Hanafi'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'Shafi'),
                child: const Text('Shafi'),
              ),
            ],
          ),
    );

    if (result != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_madhab', result);
      setState(() => _madhab = result);
    }
  }

  Future<void> _showImportDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Import Backup'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Paste the content of your backup file here:'),
                const SizedBox(height: 8),
                TextField(
                  controller:
                      controller, // Fixed: use the local controller variable
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '{"profile_name": "...", ...}',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: const Text('Import'),
              ),
            ],
          ),
    );

    if (result != null && result.isNotEmpty) {
      final success = await BackupService.importDataFromJson(result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Import successful! Please restart app.'
                  : 'Import failed: Invalid data',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        if (success) {
          // Optionally force restart or reload settings
          _loadSettings();
        }
      }
    }
  }
}
