import 'package:get/get.dart';

enum BaseState { Idle, Busy, Error }

class BaseController extends GetxController {
  // PROPERTIES
  final state = BaseState.Idle.obs;
  final errorMessage = ''.obs;
  final busyMessage = ''.obs;

  // GETTERS
  bool get busy => state.value == BaseState.Busy;
  bool get error => state.value == BaseState.Error;

  // FUNCTIONS

  // set the error state and message
  void errorState({final String message = ''}) {
    state.value = BaseState.Error;
    errorMessage.value = message;
  }

  // set the busy state and message
  void busyState({final String message = ''}) {
    state.value = BaseState.Busy;
    busyMessage.value = message;
  }

  // set the busy state and message
  void idleState({final String message}) {
    state.value = BaseState.Idle;
    busyMessage.value = message ?? 'Loading...';
  }
}
