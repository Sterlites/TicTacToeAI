import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;

  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playPenSound() async {
    await _audioPlayer.play(AssetSource('sounds/pen_writing.mp3'));
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
