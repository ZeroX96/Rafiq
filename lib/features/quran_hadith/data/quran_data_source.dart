import 'dart:convert';
import 'package:flutter/services.dart';

class QuranDataSource {
  Future<List<dynamic>> loadQuran() async {
    final String response = await rootBundle.loadString(
      'assets/json/quran.json',
    );
    final data = await json.decode(response);
    return data;
  }
}
