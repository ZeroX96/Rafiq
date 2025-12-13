import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioService {
  Future<File> downloadSurahAudio(int surahNumber) async {
    final formattedNumber = surahNumber.toString().padLeft(3, '0');
    // Using a public CDN for Quran audio (e.g., Mishary Rashid Alafasy)
    final downloadUrl = 'https://server8.mp3quran.net/afs/$formattedNumber.mp3';

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/quran_audio/$formattedNumber.mp3';
    final file = File(filePath);

    if (await file.exists()) {
      return file;
    }

    try {
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        await file.create(recursive: true);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to download audio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to download audio: $e');
    }
  }
}
