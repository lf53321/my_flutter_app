import 'package:get/get_instance/src/lifecycle.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  AudioPlayer player = AudioPlayer();

  @override
  InternalFinalCallback<void> get onDelete {
    player.stop();
    return super.onDelete;
  }
}
