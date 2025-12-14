import 'dart:convert';
import 'package:http/http.dart' as http;

class HadithService {
  static const String _baseUrl = 'https://dorar.net/dorar_api.json';

  Future<List<Map<String, dynamic>>> searchHadith(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?skey=$query'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ahadith = data['ahadith'];

        List<Map<String, dynamic>> results = [];

        if (ahadith is Map) {
          ahadith.forEach((key, value) {
            results.add({
              'text': value['hadith'] ?? value['th'] ?? '',
              'rawi': value['el_rawi'] ?? '',
              'source': value['source'] ?? '',
              'grade': value['grade'] ?? '',
              'mohaddith': value['el_mohaddith'] ?? '',
            });
          });
        } else if (ahadith is List) {
          for (var item in ahadith) {
            results.add({
              'text': item['hadith'] ?? item['th'] ?? '',
              'rawi': item['el_rawi'] ?? '',
              'source': item['source'] ?? '',
              'grade': item['grade'] ?? '',
              'mohaddith': item['el_mohaddith'] ?? '',
            });
          }
        }

        return results;
      } else {
        throw Exception('Failed to load hadith');
      }
    } catch (e) {
      throw Exception('Error searching hadith: $e');
    }
  }
}
