import 'package:flutter/services.dart';

class FeedbackService {
  /// Light haptic feedback for button taps
  static void lightTap() {
    HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback for step transitions
  static void mediumTap() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback for completion
  static void heavyTap() {
    HapticFeedback.heavyImpact();
  }

  /// Selection click haptic
  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  /// Vibrate for errors
  static void errorVibrate() {
    HapticFeedback.vibrate();
  }

  /// Play success sound
  static Future<void> playSuccess() async {
    await SystemSound.play(SystemSoundType.click);
  }

  /// Play click sound
  static Future<void> playClick() async {
    await SystemSound.play(SystemSoundType.click);
  }

  /// Play error sound
  static Future<void> playError() async {
    await SystemSound.play(SystemSoundType.click);
    errorVibrate();
  }
}
