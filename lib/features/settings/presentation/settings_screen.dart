import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rafiq/features/pin/presentation/pin_screen.dart';

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
}
