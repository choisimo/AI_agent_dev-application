import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

final userProvider = FutureProvider<UserModel?>((ref) async {
  final user = ref.watch(authProvider).value;
  if (user == null) return null;
  
  return UserModel(
    id: user.uid,
    email: user.email!,
    displayName: user.displayName,
    photoUrl: user.photoURL,
    createdAt: user.metadata.creationTime ?? DateTime.now(),
    updatedAt: DateTime.now(),
  );
});
