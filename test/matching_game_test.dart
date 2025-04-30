import 'package:flutter_test/flutter_test.dart';
import 'package:matching_game/matching_game.dart';
import 'package:matching_game/matching_game_platform_interface.dart';
import 'package:matching_game/matching_game_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMatchingGamePlatform
    with MockPlatformInterfaceMixin
    implements MatchingGamePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MatchingGamePlatform initialPlatform = MatchingGamePlatform.instance;

  test('$MethodChannelMatchingGame is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMatchingGame>());
  });

  test('getPlatformVersion', () async {
    MatchingGame matchingGamePlugin = MatchingGame();
    MockMatchingGamePlatform fakePlatform = MockMatchingGamePlatform();
    MatchingGamePlatform.instance = fakePlatform;

    expect(await matchingGamePlugin.getPlatformVersion(), '42');
  });
}
