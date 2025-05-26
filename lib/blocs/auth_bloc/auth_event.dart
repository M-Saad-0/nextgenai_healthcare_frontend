part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Authenticate extends AuthEvent {}

class GoogleAuthRequired extends AuthEvent {}
class AuthCredentialsRequired extends AuthEvent {}

class GoogleAuthCnicPhoneRequired extends AuthEvent {
  final User user;
  const GoogleAuthCnicPhoneRequired({required this.user});
  @override
  List<Object> get props => [ user];
}

class AuthLogout extends AuthEvent {}
