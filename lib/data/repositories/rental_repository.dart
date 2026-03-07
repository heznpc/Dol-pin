import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_client.dart';
import '../models/rental_item_model.dart';

final rentalRepositoryProvider = Provider<RentalRepository>((ref) {
  return RentalRepository(ref.watch(supabaseProvider));
});

class RentalRepository {
  RentalRepository(this._client);
  final SupabaseClient _client;

  Future<List<RentalItemModel>> getByConcert(String concertId) async {
    final data = await _client
        .from('rental_items')
        .select()
        .eq('concert_id', concertId)
        .eq('status', 'active')
        .order('created_at', ascending: false);
    return data.map((e) => RentalItemModel.fromJson(e)).toList();
  }

  Future<List<RentalItemModel>> getByCategory(String category) async {
    final data = await _client
        .from('rental_items')
        .select()
        .eq('category', category)
        .eq('status', 'active')
        .order('created_at', ascending: false);
    return data.map((e) => RentalItemModel.fromJson(e)).toList();
  }

  Future<RentalItemModel> getById(String id) async {
    final data =
        await _client.from('rental_items').select().eq('id', id).single();
    return RentalItemModel.fromJson(data);
  }

  Future<List<RentalItemModel>> getByLender(String lenderId) async {
    final data = await _client
        .from('rental_items')
        .select()
        .eq('lender_id', lenderId)
        .order('created_at', ascending: false);
    return data.map((e) => RentalItemModel.fromJson(e)).toList();
  }

  Future<RentalItemModel> create(Map<String, dynamic> item) async {
    final data =
        await _client.from('rental_items').insert(item).select().single();
    return RentalItemModel.fromJson(data);
  }

  Future<void> updateStatus(String id, String status) async {
    await _client.from('rental_items').update({'status': status}).eq('id', id);
  }
}
