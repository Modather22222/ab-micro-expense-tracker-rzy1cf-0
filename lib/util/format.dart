const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// Formats an amount as a plain dollar figure, e.g. 12.5 -> "$12.50".
String formatAmount(double value) {
  final negative = value < 0;
  final magnitude = value.abs();
  var whole = magnitude.floor();
  var cents = ((magnitude - whole) * 100).round();
  if (cents == 100) {
    whole += 1;
    cents = 0;
  }
  final body = '$whole.${cents.toString().padLeft(2, '0')}';
  return negative ? '-\$$body' : '\$$body';
}

/// Short relative day label: Today / Yesterday / "Oct 27".
String formatDay(DateTime date) {
  final now = DateTime.now();
  final sameDay = date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
  if (sameDay) return 'Today';
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return 'Yesterday';
  }
  return '${_months[date.month - 1]} ${date.day}';
}
