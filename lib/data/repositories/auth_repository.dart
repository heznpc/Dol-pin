import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_client.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseProvider));
});

class AuthRepository {
  AuthRepository(this._client);
  final SupabaseClient _client;

  User? get currentUser => _client.auth.currentUser;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> signInWithOtp(String phone) async {
    await _client.auth.signInWithOtp(phone: phone);
  }

  Future<AuthResponse> verifyOtp(String phone, String token) async {
    return _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  Future<bool> signInWithApple() async {
    return _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'com.dolpin.app://callback',
    );
  }

  Future<bool> signInWithGoogle() async {
    return _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'com.dolpin.app://callback',
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<UserModel?> getProfile(String userId) async {
    final data =
        await _client.from('users').select().eq('id', userId).maybeSingle();
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  Future<UserModel> createProfile(Map<String, dynamic> profile) async {
    final data =
        await _client.from('users').insert(profile).select().single();
    return UserModel.fromJson(data);
  }

  Future<UserModel> updateProfile(
      String userId, Map<String, dynamic> updates) async {
    final data = await _client
        .from('users')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();
    return UserModel.fromJson(data);
  }

  Future<void> softDelete(String userId) async {
    await _client.from('users').update({
      'deleted_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
    await _client.auth.signOut();
  }
}
