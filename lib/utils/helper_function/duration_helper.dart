class DurationHelper {
  // DO NOT INTIALIZE
  DurationHelper._();

  /// Formats a [Duration] into a string in the "MM:SS" format.
  ///
  /// This method takes a [Duration] object and converts it into a string representing
  /// the duration in minutes and seconds. The minutes are displayed as a two-digit number,
  /// and the seconds are padded with leading zeros if necessary to always show two digits.
  ///
  /// For example:
  /// - A [Duration] of 30 minutes and 5 seconds will return "30:05".
  /// - A [Duration] of 5 minutes and 9 seconds will return "05:09".
  ///
  /// Returns:
  /// - A [String] formatted as "MM:SS".
  static String toMinutesSecondsString(Duration duration) {
    final String minutes = duration.inMinutes.remainder(60).toString().padLeft(1, '0');
    final String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
