import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/rental_item_model.dart';
import '../../../shared/widgets/dolda_button.dart';
import '../../../shared/widgets/safe_badge.dart';

class ReservationScreen extends ConsumerStatefulWidget {
  const ReservationScreen({super.key, required this.item});
  final RentalItemModel item;

  @override
  ConsumerState<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends ConsumerState<ReservationScreen> {
  DateTimeRange? _dateRange;
  bool _isLoading = false;

  int get _days =>
      _dateRange != null ? _dateRange!.duration.inDays.clamp(1, 365) : 0;
  int get _rentalFee => widget.item.dailyPrice * _days;
  int get _total => _rentalFee + widget.item.deposit;

  Future<void> _selectDates() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (range != null) {
      setState(() => _dateRange = range);
    }
  }

  Future<void> _proceed() async {
    if (_dateRange == null) return;
    setState(() => _isLoading = true);
    // TODO: Create reservation + navigate to payment
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final currency = item.currency;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Rental')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: item.photos.isNotEmpty
                      ? Image.network(
                          item.photos.first,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: AppColors.surfaceLight,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${CurrencyFormatter.format(item.dailyPrice, currency)} / day',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _selectDates,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.date_range, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text(
                      _dateRange != null
                          ? DateFormatter.rentalPeriod(
                              _dateRange!.start, _dateRange!.end)
                          : 'Select rental dates',
                      style: TextStyle(
                        color: _dateRange != null
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (_dateRange != null)
                      Text(
                        '$_days day${_days > 1 ? 's' : ''}',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Price Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _PriceRow(
              label: 'Rental fee (${CurrencyFormatter.format(item.dailyPrice, currency)} x $_days days)',
              value: CurrencyFormatter.format(_rentalFee, currency),
            ),
            const SizedBox(height: 8),
            _PriceRow(
              label: 'Deposit (refundable)',
              value: CurrencyFormatter.format(item.deposit, currency),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.divider),
            ),
            _PriceRow(
              label: 'Total',
              value: CurrencyFormatter.format(_total, currency),
              isBold: true,
            ),
            const SizedBox(height: 24),
            const SafeBadge(label: 'Escrow Protected - Deposit refunded on return'),
            const SizedBox(height: 40),
            DolpinButton(
              label: 'Proceed to Payment',
              isLoading: _isLoading,
              onPressed: _dateRange != null ? _proceed : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
            fontSize: isBold ? 18 : 14,
          ),
        ),
      ],
    );
  }
}
