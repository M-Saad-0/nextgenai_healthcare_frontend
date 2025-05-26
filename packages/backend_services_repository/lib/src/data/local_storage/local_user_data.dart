import 'package:backend_services_repository/backend_service_repositoy.dart';

class LocalUserData {
  static final LocalUserData _instance = LocalUserData._internal();
  factory LocalUserData() => _instance;
  LocalUserData._internal();

  /// Ensure Hive is initialized before using this class
  Future<void> _openBox() async {
    if (!Hive.isBoxOpen('user')) {
      await Hive.openBox<User>('user');
    }
  }

  Future<void> insertUser(User user) async {
    await _openBox();
    final box = Hive.box<User>('user');
    await box.put('user', user);
  }

  bool checkUser() {
    final box = Hive.box<User>('user');
    final user = box.get('user');
    return user != null && user.password.isNotEmpty;
  }

  User? getUser() {
    final box = Hive.box<User>('user');
    final user = box.get('user');
    return user;
  }

  Future<void> clearUserTable() async {
    await _openBox();
    final box = Hive.box<User>('user');
    await box.delete('user');
  }
}
