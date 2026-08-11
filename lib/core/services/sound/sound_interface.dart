import 'package:mobiquest/core/services/sound/app_sounds.dart';

abstract class SoundInterface {

  Future<void> play(AppSounds sound);
  
}