import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:backend_services_repository/src/models/user/entities/entities.dart';
import 'package:equatable/equatable.dart';
part 'user.g.dart';

@HiveType(typeId: 2)
class User extends HiveObject implements EquatableMixin{
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String userName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;
  @HiveField(4)
  String? picture;
  @HiveField(5)
  double? personReputation;
  @HiveField(6)
  Map<String, dynamic>? location;
  @HiveField(7)
  String? cnic;
  @HiveField(8)
  String? phoneNumber;
  @HiveField(9)
  String? accountId;


  void setLocation({required double lat, required double long}) {
    location = {
      'type': "Point",
      "coordinates": [long, lat],
    };
  }

  User({
    required this.userId,
    required this.userName,
    this.password = "",
    required this.email,
    this.picture,
    this.location,
    this.personReputation = 0,
    this.cnic,
    this.phoneNumber,
    this.accountId,
  });

  static UserEntity toEntity(User user) {
    return UserEntity(
      userId: user.userId,
      password: user.password,
      userName: user.userName,
      email: user.email,
      picture: user.picture ?? "",
      location: user.location ?? {},
      personReputation: user.personReputation,
      cnic: user.cnic,
      phoneNumber: user.phoneNumber,
      accountId: user.accountId,
    );
  }

  static User fromEntity(UserEntity userEntity) {
    return User(
      userId: userEntity.userId,
      userName: userEntity.userName,
      password: userEntity.password,
      email: userEntity.email,
      picture: userEntity.picture ?? "",
      location: userEntity.location ?? {},
      personReputation: userEntity.personReputation,
      cnic: userEntity.cnic,
      phoneNumber: userEntity.phoneNumber,
      accountId: userEntity.accountId,
    );
  }

  User copyWith(
      {String? userId,
      String? userName,
      String? password,
      String? email,
      String? picture,
      Map<String, dynamic>? location,
      double? personReputation,
      String? cnic,
      String? phoneNumber,
      String? accountId}) {
    return User(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      picture: picture??this.picture,
      cnic:cnic??this.cnic,
      phoneNumber:phoneNumber??this.phoneNumber,
      personReputation:personReputation??this.personReputation,
      location:location??this.location,
      password:password??this.password,
      accountId: accountId ?? this.accountId,


    );
  }
  
  @override
  List<Object?> get props => [userId, userName, email, cnic, phoneNumber, location, picture, password, personReputation, accountId];
  
  @override
  bool? get stringify => true;
  

}
