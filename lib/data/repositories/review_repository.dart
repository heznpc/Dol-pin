import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_client.dart';
import '../models/review_model.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.watch(supabaseProvider));
});

class ReviewRepository {
  ReviewRepository(this._client);
  final SupabaseClient _client;

  Future<List<ReviewModel>> getByUser(String userId) async {
    final data = await _client
        .from('reviews')
        .select()
        .eq('reviewee_id', userId)
        .order('created_at', ascending: false);
    return data.map((e) => ReviewModel.fromJson(e)).toList();
  }

  Future<ReviewModel> create(Map<String, dynamic> review) async {
    final data =
        await _client.from('reviews').insert(review).select().single();
    return ReviewModel.fromJson(data);
  }

  Future<double> getAverageRating(String userId) async {
    final data = await _client
        .from('reviews')
        .select('rating')
        .eq('reviewee_id', userId);
    if (data.isEmpty) return 0;
    final sum = data.fold<int>(0, (sum, e) => sum + (e['rating'] as int));
    return sum / data.length;
  }
}
