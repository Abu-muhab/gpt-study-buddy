import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_study_buddy/auth/data/auth_token.dart';
import 'package:gpt_study_buddy/auth/data/auth_token_repo.dart';
import 'package:gpt_study_buddy/auth/data/dtos.dart';
import 'package:gpt_study_buddy/common/exception.dart';
import 'package:gpt_study_buddy/common/http_client.dart';

class AuthService {
  AuthService({
    required this.autTokenRep,
    required this.httpClient,
  });

  final AuthTokenRepo autTokenRep;
  final AppHttpClient httpClient;

  Future<AuthToken> login(LoginRequest request) async {
    final FailureOrResponse response = await httpClient.post(
        '${dotenv.env['SERVER_URL']}/users/login', request.toJson());

    if (response.isSuccess) {
      final AuthToken authData = AuthToken.fromMap(response.response);
      await autTokenRep.saveAuthToken(authData);
      return authData;
    } else {
      throw DomainException(response.errorMessage);
    }
  }

  Future<AuthToken> signup(SignupRequest request) async {
    final FailureOrResponse response = await httpClient.post(
        '${dotenv.env['SERVER_URL']}/users', request.toJson());

    if (response.isSuccess) {
      final AuthToken authData = AuthToken.fromMap(response.response);
      await autTokenRep.saveAuthToken(authData);
      return authData;
    } else {
      throw DomainException(response.errorMessage);
    }
  }
}
