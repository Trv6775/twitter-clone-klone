import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_klone_clone/apis/apis..dart';

import 'package:twitter_klone_clone/core/core.dart';
import 'package:twitter_klone_clone/features/auth/view/login_view.dart';
import 'package:twitter_klone_clone/features/home/views/home_view.dart';
import 'package:appwrite/models.dart' as model;

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {
    final authAPI = ref.watch(authAPIProvider);
    final userAPI = ref.watch(userAPIProvider);
    return AuthController(
      authAPI: authAPI,
      userAPI: userAPI,
    );
  },
);
final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Account created successfully! Please login.');
        Navigator.push(
          context,
          LoginView.route(),
        );
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.push(
          context,
          HomeView.route(),
        );
      },
    );
  }

  Future<model.User?> currentUser() {
    return _authAPI.currentUserAccount();
  }
}
