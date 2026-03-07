import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/concert_model.dart';
import '../data/repositories/concert_repository.dart';

final upcomingConcertsProvider =
    FutureProvider.family<List<ConcertModel>, String?>((ref, country) {
  return ref.watch(concertRepositoryProvider).getUpcoming(country: country);
});

final concertDetailProvider =
    FutureProvider.family<ConcertModel, String>((ref, id) {
  return ref.watch(concertRepositoryProvider).getById(id);
});
