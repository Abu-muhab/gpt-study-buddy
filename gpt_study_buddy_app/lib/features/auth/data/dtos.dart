class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.empty() => LoginRequest(
        email: '',
        password: '',
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  LoginRequest copyWith({
    String? email,
    String? password,
  }) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class SignupRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  SignupRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  factory SignupRequest.empty() => SignupRequest(
        email: '',
        password: '',
        firstName: '',
        lastName: '',
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      };

  SignupRequest copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
  }) {
    return SignupRequest(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}
