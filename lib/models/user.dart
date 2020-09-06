class User {
  final String userId;
  final String email;
  final String token;
  final DateTime expiresIn;

  User({ this.userId, this.email, this.token, this.expiresIn });

  Map<String, dynamic> toJson() =>
    {
      'userId': userId,
      'email': email,
      'token': token,
      'expiresIn': expiresIn.toIso8601String()
    };
}
