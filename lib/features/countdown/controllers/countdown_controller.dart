import 'package:get/get.dart';

class CountdownController extends GetxController {
  final RxInt currentCount = 3.obs;
  final RxBool isGo = false.obs;
  final RxBool isDone = false.obs;

  @override
  void onReady() {
    super.onReady();
    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = 3; i >= 1; i--) {
      currentCount.value = i;
      await Future.delayed(const Duration(seconds: 1));
    }
    isGo.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isDone.value = true;
    // Navigation is handled by CountdownScreen via ever() listener
    // so we have direct access to the GoRouter context
  }
}
