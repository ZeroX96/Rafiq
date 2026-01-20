import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class BackupService {
  /// Exports all SharedPreferences data to a JSON file and opens the Share sheet.
  static Future<void> exportData(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allData = prefs.getKeys().fold<Map<String, dynamic>>({}, (
        map,
        key,
      ) {
        map[key] = prefs.get(key);
        return map;
      });

      // Add metadata
      allData['export_date'] = DateTime.now().toIso8601String();
      allData['app_version'] = '1.0.0';

      final jsonString = jsonEncode(allData);

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final dateStr = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final fileName = 'rafiq_backup_$dateStr.json';
      final file = File('${directory.path}/$fileName');

      // Write to file
      await file.writeAsString(jsonString);

      // Share file
      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: 'My Rafiq App Data Backup');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export ready via Share Sheet')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  /// Imports data from a JSON string (e.g., from Clipboard or File).
  /// Returns validation status.
  static Future<bool> importDataFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);

      // key validation
      if (!data.containsKey('app_version')) {
        return false; // Not a valid backup
      }

      final prefs = await SharedPreferences.getInstance();

      // Clear current data? Maybe unsafe.
      // Safe approach: Overwrite keys from backup.

      for (var key in data.keys) {
        final value = data[key];
        if (value is String)
          await prefs.setString(key, value);
        else if (value is int)
          await prefs.setInt(key, value);
        else if (value is bool)
          await prefs.setBool(key, value);
        else if (value is double)
          await prefs.setDouble(key, value);
        else if (value is List)
          await prefs.setStringList(key, List<String>.from(value));
      }

      return true;
    } catch (e) {
      debugPrint('Import validation failed: $e');
      return false;
    }
  }
}
