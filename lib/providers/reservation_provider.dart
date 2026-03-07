import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/reservation_model.dart';
import '../data/repositories/reservation_repository.dart';

final borrowerReservationsProvider =
    FutureProvider.family<List<ReservationModel>, String>((ref, borrowerId) {
  return ref.watch(reservationRepositoryProvider).getByBorrower(borrowerId);
});

final lenderReservationsProvider =
    FutureProvider.family<List<ReservationModel>, String>((ref, lenderId) {
  return ref.watch(reservationRepositoryProvider).getByLender(lenderId);
});

final reservationDetailProvider =
    FutureProvider.family<ReservationModel, String>((ref, id) {
  return ref.watch(reservationRepositoryProvider).getById(id);
});
