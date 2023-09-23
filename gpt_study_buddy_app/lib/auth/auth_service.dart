import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_study_buddy/auth/data/auth_token.dart';
import 'package:gpt_study_buddy/auth/data/auth_token_repo.dart';
import 'package:gpt_study_buddy/auth/data/dtos.dart';
import 'package:gpt_study_buddy/common/http_client.dart';

class AuthService {
  AuthService({
    required this.autTokenRep,
  });

  final AuthTokenRepo autTokenRep;
  Future<AuthToken> login(LoginRequest request) async {
    final FailureOrResponse response = await AppHttpClient.post(
        '${dotenv.env['SERVER_URL']}/users/login', request.toJson());

    if (response.isSuccess) {
      final AuthToken authData = AuthToken.fromMap(response.response);
      await autTokenRep.saveAuthToken(authData);
      return authData;
    } else {
      throw AuthException(response.errorMessage);
    }
  }

  Future<AuthToken> signup(SignupRequest request) async {
    final FailureOrResponse response = await AppHttpClient.post(
        '${dotenv.env['SERVER_URL']}/users', request.toJson());

    if (response.isSuccess) {
      final AuthToken authData = AuthToken.fromMap(response.response);
      await autTokenRep.saveAuthToken(authData);
      return authData;
    } else {
      throw AuthException(response.errorMessage);
    }
  }
}

class AuthException implements Exception {
  late final String message;

  AuthException(String? message) {
    this.message = message ?? 'An error occurred';
  }
}
