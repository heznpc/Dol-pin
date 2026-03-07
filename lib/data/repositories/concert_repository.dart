import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_client.dart';
import '../models/concert_model.dart';

final concertRepositoryProvider = Provider<ConcertRepository>((ref) {
  return ConcertRepository(ref.watch(supabaseProvider));
});

class ConcertRepository {
  ConcertRepository(this._client);
  final SupabaseClient _client;

  Future<List<ConcertModel>> getUpcoming({String? country}) async {
    var query = _client
        .from('concerts')
        .select()
        .gte('concert_date', DateTime.now().toIso8601String());

    if (country != null) {
      query = query.eq('country', country);
    }

    final data = await query.order('concert_date');
    return data.map((e) => ConcertModel.fromJson(e)).toList();
  }

  Future<ConcertModel> getById(String id) async {
    final data = await _client.from('concerts').select().eq('id', id).single();
    return ConcertModel.fromJson(data);
  }

  Future<List<ConcertModel>> searchByArtist(String artist) async {
    final data = await _client
        .from('concerts')
        .select()
        .ilike('artist', '%$artist%')
        .order('concert_date');
    return data.map((e) => ConcertModel.fromJson(e)).toList();
  }
}
