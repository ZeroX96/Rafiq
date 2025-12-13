import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class FeedbackService {
  static final AudioPlayer _player = AudioPlayer();

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
    try {
      await _player.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      // Fallback to haptic if audio fails
      heavyTap();
    }
  }

  /// Play click sound
  static Future<void> playClick() async {
    try {
      await _player.play(AssetSource('sounds/click.mp3'));
    } catch (e) {
      lightTap();
    }
  }

  /// Play error sound
  static Future<void> playError() async {
    try {
      await _player.play(AssetSource('sounds/error.mp3'));
    } catch (e) {
      errorVibrate();
    }
  }
}
