import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/features/auth/auth_service.dart';
import 'package:gpt_study_buddy/features/auth/data/auth_token.dart';
import 'package:gpt_study_buddy/features/auth/data/dtos.dart';

import '../data/auth_token_repo.dart';

class AuthServiceProvider extends ChangeNotifier {
  AuthServiceProvider({
    required this.authService,
    required this.autTokenRep,
  }) {
    init();
  }

  final AuthService authService;
  final AuthTokenRepo autTokenRep;

  AuthToken? _authToken;
  AuthToken? get authToken => _authToken;
  set authToken(AuthToken? value) {
    _authToken = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoggedIn => _authToken?.user != null && _authToken?.token != null;
  final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier<bool>(false);

  Future<void> login(LoginRequest request) async {
    try {
      isLoading = true;
      setLoggedInState(await authService.login(request));
      isLoading = false;
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> signup(SignupRequest request) async {
    try {
      isLoading = true;
      setLoggedInState(await authService.signup(request));
      isLoading = false;
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> init() async {
    try {
      isLoading = true;
      setLoggedInState(await autTokenRep.getAuthToken());
      isLoading = false;
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  void setLoggedInState(AuthToken? authToken) {
    this.authToken = authToken;
    if (authToken != null) {
      isLoggedInNotifier.value = true;
    }
  }
}
