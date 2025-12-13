import 'package:adhan/adhan.dart';

class PrayerService {
  PrayerTimes getPrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
    required CalculationMethod method,
    required Madhab madhab,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = method.getParameters();
    params.madhab = madhab;

    // Using UTC date components to avoid timezone issues, Adhan handles conversion if needed but usually expects local date components
    final dateComponents = DateComponents(date.year, date.month, date.day);

    return PrayerTimes(coordinates, dateComponents, params);
  }
}
