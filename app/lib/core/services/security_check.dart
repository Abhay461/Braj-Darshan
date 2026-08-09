import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class SecurityCheck {
  /// Checks for root/jailbreak and exits the app if detected.
  static Future<void> enforceDeviceSecurity() async {
    try {
      final bool isJailBroken = await FlutterJailbreakDetection.jailbroken;
      if (isJailBroken) {
        debugPrint('Rooted/jailbroken device detected - exiting');
        // Exit the app gracefully
        SystemNavigator.pop();
      }
    } catch (e) {
      debugPrint('Device security check failed: $e');
    }
    // TODO: Add tamper detection logic if a suitable package is added in the future.
  }
}
