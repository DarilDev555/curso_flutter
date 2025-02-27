class User {
  final String id;
  final String email;
  final String fulname;
  final List<String> roles;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.fulname,
    required this.roles,
    required this.token,
  });

  bool get isAdmin {
    return roles.contains('admin');
  }
}
