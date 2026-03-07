import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(int amountMinor, String currency) {
    final format = switch (currency) {
      'KRW' => NumberFormat('#,###', 'ko'),
      'IDR' => NumberFormat('#,###', 'id'),
      'JPY' => NumberFormat('#,###', 'ja'),
      _ => NumberFormat('#,##0.00', 'en'),
    };

    final symbol = switch (currency) {
      'KRW' => '\u20A9',
      'IDR' => 'Rp',
      'JPY' => '\u00A5',
      'USD' => '\$',
      _ => currency,
    };

    // KRW, JPY, IDR are zero-decimal currencies
    final amount = switch (currency) {
      'KRW' || 'JPY' || 'IDR' => amountMinor,
      _ => amountMinor / 100,
    };

    return '$symbol${format.format(amount)}';
  }
}

class DateFormatter {
  static String concertDate(DateTime date) {
    return DateFormat('MMM d, yyyy (E)').format(date);
  }

  static String rentalPeriod(DateTime from, DateTime to) {
    final f = DateFormat('M/d');
    return '${f.format(from)} - ${f.format(to)}';
  }

  static String relative(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('M/d').format(date);
  }
}
