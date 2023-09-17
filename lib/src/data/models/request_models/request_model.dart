class RegisterRequest {
  final String name;
  final String? nickName;
  final String? birth;
  final String? email;
  final String? image;
  final Gender? gender;

  const RegisterRequest({
    required this.name,
    this.nickName,
    this.birth,
    this.email,
    this.image,
    this.gender,
  });
}

enum Gender {
  male(1),
  female(0);

  const Gender(this.val);

  final int val;
}
