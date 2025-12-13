import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rafiq/core/database/app_database.dart';

class ExportService {
  final AppDatabase db;

  ExportService(this.db);

  Future<void> exportData() async {
    final prayers = await db.select(db.prayers).get();
    final qada = await db.select(db.qada).get();
    final azkar = await db.select(db.azkar).get();

    final data = {
      'prayers': prayers.map((e) => e.toJson()).toList(),
      'qada': qada.map((e) => e.toJson()).toList(),
      'azkar': azkar.map((e) => e.toJson()).toList(),
    };

    final jsonString = jsonEncode(data);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/rafiq_backup.json');
    await file.writeAsString(jsonString);

    await Share.shareXFiles([XFile(file.path)], text: 'Rafiq App Data Backup');
  }
}
