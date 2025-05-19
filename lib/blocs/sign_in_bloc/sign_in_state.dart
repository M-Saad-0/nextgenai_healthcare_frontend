part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();
  
  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}
final class SignInLoading extends SignInState {}
final class SignInSuccess extends SignInState {
  final User user;
  const SignInSuccess({required this.user});
    @override
  List<Object> get props => [user];
}
final class SignInError extends SignInState {
    final String error;
  const SignInError({required this.error});
    @override
  List<Object> get props => [error];
}
