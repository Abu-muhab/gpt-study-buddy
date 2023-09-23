import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'auth_token.dart';

class AuthTokenRepo {
  Future<void> saveAuthToken(AuthToken authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authData', jsonEncode(authToken.toMap()));
  }

  Future<AuthToken?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authDataString = prefs.getString('authData');
    if (authDataString == null) {
      return null;
    }

    Map<String, dynamic> authDataMap =
        jsonDecode(authDataString) as Map<String, dynamic>;

    return AuthToken.fromMap(authDataMap);
  }
}
