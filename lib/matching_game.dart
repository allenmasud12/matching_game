
import 'matching_game_platform_interface.dart';

class MatchingGame {
  Future<String?> getPlatformVersion() {
    return MatchingGamePlatform.instance.getPlatformVersion();
  }
}
