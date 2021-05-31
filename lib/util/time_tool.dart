class TimeTool {
  //时间格式化，根据总秒数转换为对应的 hh:mm:ss 格式
  static String constructTime(int seconds) {
    int day = seconds ~/ 3600 ~/ 24;
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    if (day != 0) {
      return '$day-$hour:$minute:$second';
    } else if (hour != 0) {
      return '$hour:$minute:$second';
    } else if (minute != 0) {
      return '$minute:$second';
    } else if (second != 0) {
      return '$second';
    } else {
      return '';
    }
//    return formatTime(day)+'天'+formatTime(hour) + "小时" + formatTime(minute) + "分" + formatTime(second)+'秒后自动取消';
  }

  static String constructMinuteTime(int seconds) {
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(minute) + ":" + formatTime(second);
  }

  //数字格式化，将 0~9 的时间转换为 00~09
  static String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }
}
