class Logger {
  static println(String message) {
    printWrapped(message);
  }

  static printTag(String tag, String message) {
    println("$tag : $message");
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
