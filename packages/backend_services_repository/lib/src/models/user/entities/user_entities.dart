class UserEntity {
  final String userId;
  final String userName;
  final String email;
  final String password;
  String? picture;
  double? personReputation;
  Map<String, dynamic>? location;
  String? cnic;
  String? phoneNumber;
  String? accountId;

  UserEntity({
    required this.userId,
    required this.userName,
    required this.email,
    this.picture,
    this.location,
    this.password = "",
    this.personReputation = 0,
    this.cnic,
    this.phoneNumber,
    this.accountId,

  });

  static UserEntity fromJson(Map<String, dynamic> jsonObject) {
    return UserEntity(
      userId: jsonObject['_id'],
      userName: jsonObject['userName'],
      email: jsonObject['email'],
      picture: jsonObject['picture'],
      password: jsonObject['password'],
      personReputation: jsonObject['personReputation']?.toDouble() ?? 0,
      location: jsonObject['location'] ?? {},
      cnic: jsonObject['cnic'],
      phoneNumber: jsonObject['phoneNumber'],
      accountId: jsonObject['accountId'],
    );
  }

  static Map<String, dynamic> toJson(UserEntity userEntity) {
    return {
      'userId': userEntity.userId,
      'userName': userEntity.userName,
      'email': userEntity.email,
      'password': userEntity.password,
      'picture': userEntity.picture,
      'personReputation': userEntity.personReputation,
      'location': userEntity.location ?? {},
      'cnic': userEntity.cnic,
      'phoneNumber': userEntity.phoneNumber,
      'accountId': userEntity.accountId,
    };
  }
}
