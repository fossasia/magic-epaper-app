class DateUtils {
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      final remainingDays = difference.inDays % 365;
      final months = (remainingDays / 30).floor();
      if (months > 0) {
        return '$years year${years > 1 ? 's' : ''} $months month${months > 1 ? 's' : ''} ago';
      }
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      final remainingDays = difference.inDays % 30;
      if (remainingDays > 0) {
        return '$months month${months > 1 ? 's' : ''} $remainingDays day${remainingDays > 1 ? 's' : ''} ago';
      }
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      final remainingDays = difference.inDays % 7;
      if (remainingDays > 0) {
        return '$weeks week${weeks > 1 ? 's' : ''} $remainingDays day${remainingDays > 1 ? 's' : ''} ago';
      }
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays > 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Now';
    }
  }

  static String formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
