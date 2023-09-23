import 'dart:math';

class ImageAssets {
  static const String robot1 = 'assets/robot1.png';
  static const String robot2 = 'assets/robot2.png';
  static const String robot3 = 'assets/robot3.png';
  static const String robot4 = 'assets/robot4.png';
  static const String robot5 = 'assets/robot5.png';

  static String randomRobot() {
    final random = Random();
    final robots = [
      robot1,
      robot2,
      robot3,
      robot4,
      robot5,
    ];
    return robots[random.nextInt(robots.length)];
  }
}
