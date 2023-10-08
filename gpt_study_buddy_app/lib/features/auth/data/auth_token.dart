import 'package:gpt_study_buddy/features/auth/data/user.dart';

class AuthToken {
  AuthToken({
    this.user,
    this.token,
  });

  factory AuthToken.fromMap(Map<String, dynamic> map) {
    return AuthToken(
      user: User.fromMap(map['user']),
      token: map['token'],
    );
  }

  final User? user;
  final String? token;

  AuthToken copyWith({
    User? user,
    String? token,
  }) {
    return AuthToken(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'token': token,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthToken &&
        other.user?.id == user?.id &&
        other.token == token;
  }

  @override
  int get hashCode => user.hashCode ^ token.hashCode;
}
