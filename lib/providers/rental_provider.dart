import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/rental_item_model.dart';
import '../data/repositories/rental_repository.dart';

final rentalsByConcertProvider =
    FutureProvider.family<List<RentalItemModel>, String>((ref, concertId) {
  return ref.watch(rentalRepositoryProvider).getByConcert(concertId);
});

final rentalsByCategoryProvider =
    FutureProvider.family<List<RentalItemModel>, String>((ref, category) {
  return ref.watch(rentalRepositoryProvider).getByCategory(category);
});

final rentalDetailProvider =
    FutureProvider.family<RentalItemModel, String>((ref, id) {
  return ref.watch(rentalRepositoryProvider).getById(id);
});

final myRentalsProvider =
    FutureProvider.family<List<RentalItemModel>, String>((ref, lenderId) {
  return ref.watch(rentalRepositoryProvider).getByLender(lenderId);
});
