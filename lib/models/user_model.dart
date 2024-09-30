class UserModel  {
  late String id;
  late String name;
  late String email;

  static UserModel? _instance;

  UserModel._({
    required this.id,
    required this.name,
    required this.email,
  });

  static UserModel get getInstance {
    return _instance!;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    _instance = UserModel._(
      id: json["id"]!,
      name: json["name"]!,
      email: json["email"]!,
    );
    return _instance!;
  }
}
