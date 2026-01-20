import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  static const String androidWidgetName = 'HomeWidgetProvider';

  /// Updates the widget with the next prayer name and time.
  static Future<void> updateNextPrayer(String prayerName, String time) async {
    try {
      await HomeWidget.saveWidgetData<String>('prayer_name', prayerName);
      await HomeWidget.saveWidgetData<String>('prayer_time', time);
      await HomeWidget.updateWidget(
        name: androidWidgetName,
        iOSName: 'RafiqWidget', // Placeholder for iOS
      );
      debugPrint('Widget Updated: $prayerName at $time');
    } catch (e) {
      debugPrint('Widget Update Failed: $e');
    }
  }
}
