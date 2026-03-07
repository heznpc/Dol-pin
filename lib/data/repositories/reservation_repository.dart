import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_client.dart';
import '../models/reservation_model.dart';

final reservationRepositoryProvider =
    Provider<ReservationRepository>((ref) {
  return ReservationRepository(ref.watch(supabaseProvider));
});

class ReservationRepository {
  ReservationRepository(this._client);
  final SupabaseClient _client;

  Future<ReservationModel> create(Map<String, dynamic> reservation) async {
    final data = await _client
        .from('reservations')
        .insert(reservation)
        .select()
        .single();
    return ReservationModel.fromJson(data);
  }

  Future<List<ReservationModel>> getByBorrower(String borrowerId) async {
    final data = await _client
        .from('reservations')
        .select()
        .eq('borrower_id', borrowerId)
        .order('created_at', ascending: false);
    return data.map((e) => ReservationModel.fromJson(e)).toList();
  }

  Future<List<ReservationModel>> getByLender(String lenderId) async {
    final data = await _client
        .from('reservations')
        .select()
        .eq('lender_id', lenderId)
        .order('created_at', ascending: false);
    return data.map((e) => ReservationModel.fromJson(e)).toList();
  }

  Future<ReservationModel> getById(String id) async {
    final data =
        await _client.from('reservations').select().eq('id', id).single();
    return ReservationModel.fromJson(data);
  }

  Future<void> updateStatus(String id, String status) async {
    await _client
        .from('reservations')
        .update({'status': status}).eq('id', id);
  }

  Future<void> confirmPickup(String id) async {
    await _client.from('reservations').update({
      'status': 'picked_up',
      'pickup_confirmed_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> confirmReturn(String id, {String? returnPhoto}) async {
    final updates = <String, dynamic>{
      'status': 'returned',
      'return_confirmed_at': DateTime.now().toIso8601String(),
    };
    if (returnPhoto != null) updates['return_photo'] = returnPhoto;
    await _client.from('reservations').update(updates).eq('id', id);
  }
}
