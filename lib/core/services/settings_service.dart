import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsServiceProvider = Provider((ref) => SettingsService());

class SettingsService {
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyLat = 'selected_lat';
  static const String _keyLng = 'selected_lng';
  static const String _keyCityName = 'selected_city_name';

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
  }

  Future<void> saveLocation(double lat, double lng, String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyLat, lat);
    await prefs.setDouble(_keyLng, lng);
    await prefs.setString(_keyCityName, cityName);
  }

  Future<Map<String, dynamic>?> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_keyLat);
    final lng = prefs.getDouble(_keyLng);
    final name = prefs.getString(_keyCityName);

    if (lat != null && lng != null && name != null) {
      return {'lat': lat, 'lng': lng, 'name': name};
    }
    return null;
  }
}
