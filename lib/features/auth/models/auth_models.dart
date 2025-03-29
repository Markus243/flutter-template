class UserDto {
  final String username;
  final String password;

  UserDto({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        username: json['username'] as String,
        password: json['password'] as String,
      );
}

class CreateUserDto extends UserDto {
  final String? email;
  final String firstName;
  final String lastName;
  final String role;

  CreateUserDto({
    required String username,
    required String password,
    this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  }) : super(username: username, password: password);

  @override
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
      };

  factory CreateUserDto.fromJson(Map<String, dynamic> json) => CreateUserDto(
        username: json['username'] as String,
        password: json['password'] as String,
        email: json['email'] as String?,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        role: json['role'] as String,
      );
}

class AuthResponse {
  final String token;
  final String refreshToken;
  final DateTime expiresIn;

  AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
        'refreshToken': refreshToken,
        'expiresIn': expiresIn.toIso8601String(),
      };

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: json['token'] as String,
        refreshToken: json['refreshToken'] as String,
        expiresIn: DateTime.parse(json['expiresIn'] as String),
      );
}

class RefreshTokenRequestDto {
  final int userId;
  final String refreshToken;

  RefreshTokenRequestDto({
    required this.userId,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'refreshToken': refreshToken,
      };

  factory RefreshTokenRequestDto.fromJson(Map<String, dynamic> json) =>
      RefreshTokenRequestDto(
        userId: json['userId'] as int,
        refreshToken: json['refreshToken'] as String,
      );
}

class TokenResponseDto {
  final int id;
  final String token;
  final String refreshToken;
  final String userName;
  final String firstName;
  final String lastName;

  TokenResponseDto({
    required this.id,
    required this.token,
    required this.refreshToken,
    required this.userName,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'refreshToken': refreshToken,
        'userName': userName,
        'firstName': firstName,
        'lastName': lastName,
      };

  factory TokenResponseDto.fromJson(Map<String, dynamic> json) =>
      TokenResponseDto(
        id: json['id'] as int,
        token: json['token'] as String,
        refreshToken: json['refreshToken'] as String,
        userName: json['userName'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
      );
}
