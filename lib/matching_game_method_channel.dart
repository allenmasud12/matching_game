import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'matching_game_platform_interface.dart';

/// An implementation of [MatchingGamePlatform] that uses method channels.
class MethodChannelMatchingGame extends MatchingGamePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('matching_game');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
