import 'package:audioplayers/audioplayers.dart';
import 'sound_interface.dart';
import 'app_sounds.dart';

class SoundRepository implements SoundInterface {
  final AudioPlayer _player = AudioPlayer();

  @override
  Future<void> play(AppSounds sound) async {
    await _player.play(AssetSource(sound.path));
  }
}