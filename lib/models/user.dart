class User {
  final String email;
  final String username;
  final String password;
  final String role;
  final bool isLogged;

  User({
    required this.email,
    required this.username,
    required this.password,
    required this.role,
    required this.isLogged,
  });
}
