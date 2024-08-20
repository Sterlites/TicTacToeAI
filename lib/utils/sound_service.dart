import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static AudioPlayer? _backgroundMusicPlayer;
  static AudioPlayer? _effectPlayer;

  static Future<void> initialize() async {
    _backgroundMusicPlayer = AudioPlayer();
    _effectPlayer = AudioPlayer();
  }

  static Future<void> playBackgroundMusic(String assetPath) async {
    await _backgroundMusicPlayer?.stop();
    await _backgroundMusicPlayer?.setReleaseMode(ReleaseMode.loop);
    await _backgroundMusicPlayer?.setSourceAsset(assetPath);
    await _backgroundMusicPlayer?.resume();
  }

  static Future<void> playSoundEffect(String assetPath) async {
    await _effectPlayer?.setSourceAsset(assetPath);
    await _effectPlayer?.resume();
  }

  static Future<void> stopBackgroundMusic() async {
    await _backgroundMusicPlayer?.stop();
  }

  static Future<void> dispose() async {
    await _backgroundMusicPlayer?.dispose();
    await _effectPlayer?.dispose();
    _backgroundMusicPlayer = null;
    _effectPlayer = null;
  }
}
