import 'package:get/get.dart';

enum BaseState { Idle, Busy, Error }

class BaseController extends GetxController {
  // PROPERTIES
  final state = BaseState.Idle.obs;
  final message = ''.obs;

  // GETTERS
  bool get busy => state.value == BaseState.Busy;
  bool get error => state.value == BaseState.Error;

  // FUNCTIONS

  // set the error state and message
  void errorState({final String text = ''}) {
    state.value = BaseState.Error;
    message.value = text;
  }

  // set the busy state and message
  void busyState({final String text = ''}) {
    state.value = BaseState.Busy;
    message.value = text;
  }

  // set the busy state and message
  void idleState({final String text = ''}) {
    state.value = BaseState.Idle;
    message.value = text;
  }
}
