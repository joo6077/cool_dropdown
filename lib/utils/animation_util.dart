class AnimationUtil {
  Duration disable = Duration(milliseconds: 0);

  Duration isAnimation(
      {required bool status,
      Duration duration = const Duration(milliseconds: 0)}) {
    if (status) {
      return duration;
    } else {
      return disable;
    }
  }
}
