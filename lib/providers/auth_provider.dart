import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) async {
      final user = state.session?.user;
      if (user == null) return null;
      return ref.read(authRepositoryProvider).getProfile(user.id);
    },
    loading: () => null,
    error: (_, _) => null,
  );
});
