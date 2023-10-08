import 'dart:convert';

import 'package:gpt_study_buddy/features/auth/data/auth_token.dart';
import 'package:gpt_study_buddy/features/auth/data/auth_token_repo.dart';
import 'package:http/http.dart' as http;

class AppHttpClient {
  AppHttpClient({
    required this.authTokenRepo,
  });

  final AuthTokenRepo authTokenRepo;

  Future<FailureOrResponse> get(String url) async {
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        ...await getAuthHeader(),
      },
    );

    if (response.statusCode.toString().startsWith('2')) {
      return FailureOrResponse(
        isSuccess: true,
        response: jsonDecode(response.body),
      );
    } else {
      if (response.statusCode == 401) {
        await authTokenRepo.deleteAuthToken();
      }

      return FailureOrResponse(
        response: null,
        isSuccess: false,
        errorMessage: parseErrorResponse(response.body),
      );
    }
  }

  Future<FailureOrResponse> post(String url, Map<String, dynamic> body) async {
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        ...await getAuthHeader(),
      },
      body: const JsonEncoder().convert(body),
    );

    if (response.statusCode.toString().startsWith('2')) {
      return FailureOrResponse(
        isSuccess: true,
        response: jsonDecode(response.body),
      );
    } else {
      if (response.statusCode == 401) {
        await authTokenRepo.deleteAuthToken();
      }

      return FailureOrResponse(
        response: null,
        isSuccess: false,
        errorMessage: parseErrorResponse(response.body),
      );
    }
  }

  static String? parseErrorResponse(dynamic error) {
    dynamic parsedError;
    try {
      parsedError = jsonDecode(error);
    } catch (_) {}

    if (parsedError == null) {
      return null;
    } else if (parsedError is String) {
      return parsedError;
    } else if (parsedError is Map<String, dynamic> &&
        parsedError['message'] is String) {
      return parsedError['message'];
    } else if (parsedError is Map<String, dynamic> &&
        parsedError['message'] is List) {
      return parsedError['message'].first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getAuthHeader() async {
    final AuthToken? authToken = await authTokenRepo.getAuthToken();
    if (authToken == null) {
      return {};
    }
    return <String, String>{
      'Authorization': 'Bearer ${authToken.token}',
    };
  }
}

class FailureOrResponse {
  final dynamic response;
  final String? errorMessage;
  final bool isSuccess;

  FailureOrResponse({
    this.response,
    this.errorMessage,
    required this.isSuccess,
  });
}
