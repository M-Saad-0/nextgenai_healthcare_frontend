part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Authenticate extends AuthEvent {}

class GoogleAuthRequired extends AuthEvent {}

class GoogleAuthCnicPhoneRequired extends AuthEvent {
  final String cnic;
  final String phoneNumber;
  const GoogleAuthCnicPhoneRequired(
      {required this.cnic, required this.phoneNumber});
  @override
  List<Object> get props => [cnic, phoneNumber];
}

class AuthLogout extends AuthEvent {}
