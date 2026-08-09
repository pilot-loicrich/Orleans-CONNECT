/// Formatage de dates/heures en français, sans dépendance de locale externe
/// (suffisant pour le MVP ; migrable vers `intl` + `initializeDateFormatting`).
abstract final class DateFormatFr {
  static const _months = [
    'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
    'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
  ];

  /// Ancre temporelle de la démo (cohérente avec les données mockées).
  static DateTime now = DateTime(2026, 8, 9, 9, 0);

  /// Ex. « il y a 3 h », « il y a 2 j », ou une date pour les plus anciens.
  static String relative(DateTime date) {
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'à l\'instant';
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours} h';
    if (diff.inDays < 7) return 'il y a ${diff.inDays} j';
    return dayMonth(date);
  }

  /// Ex. « 9 août ».
  static String dayMonth(DateTime date) =>
      '${date.day} ${_months[date.month - 1]}';

  /// Ex. « 10:30 ».
  static String time(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
