import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'matching_game_method_channel.dart';

abstract class MatchingGamePlatform extends PlatformInterface {
  /// Constructs a MatchingGamePlatform.
  MatchingGamePlatform() : super(token: _token);

  static final Object _token = Object();

  static MatchingGamePlatform _instance = MethodChannelMatchingGame();

  /// The default instance of [MatchingGamePlatform] to use.
  ///
  /// Defaults to [MethodChannelMatchingGame].
  static MatchingGamePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MatchingGamePlatform] when
  /// they register themselves.
  static set instance(MatchingGamePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
