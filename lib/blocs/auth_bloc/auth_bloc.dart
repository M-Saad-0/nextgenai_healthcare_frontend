import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationImp authentication;
  AuthBloc({required this.authentication}) : super(AuthInitial()) {
    on<Authenticate>((event, emit) async {
      print("Event ${event}");
      emit(AuthLoading());
      try {
        User? user = authentication.checkUserAccountOnStartUp();
        if (user != null) {
          final location = await LocationServicesImp().getLocation();
          user.setLocation(
              lat: location['latitude'], long: location['longitude']);
          emit(AuthLoadingSuccess(user: user));
        } else {
          debugPrint("here");
          emit(AuthError());
        }
      } catch (e) {
        print(e.toString());
        emit(AuthError());
      }
    });

    on<AuthLogout>((event, emit) async {
      emit(AuthLogOutLoading());
      if (await GoogleSignInAuth.isUserLoggedInWithGoogle()) {
        await GoogleSignInAuth.logOut();
      }
      print("***************************************************");
      await authentication.logout();
      emit(AuthLogoutState());
      // add(Authenticate());
    });

    on<GoogleAuthRequired>((event, emit) async {
      try {
        if (await GoogleSignInAuth.isUserLoggedInWithGoogle()) {
          await GoogleSignInAuth.logOut();
        } else {
          final account = await GoogleSignInAuth.login();

          print("$account");
          Map<String, dynamic> userLocation =
              await LocationServicesImp().getLocation();
          print(userLocation);
          final user = User(
              userId: account!.id,
              userName: account.displayName ?? "",
              email: account.email,
              location: {
                'type': "Point",
                "coordinates": [
                  userLocation['longitude'],
                  userLocation['latitude'],
                ]
              },
              picture: account.photoUrl ?? "");
          final googleAuntentication = await account.authentication;
          // print("${googleAuntentication.idToken}");
          final Result<User, String> result =
              await authentication.loginWithGoogle(
                  user: user, idToken: googleAuntentication.idToken);
          if (result.isFailure) {
            emit(AuthError());
          } else if (result.isSuccess) {
            print("result.value!.cnic${result.value!.cnic}");
            
            if (result.value!.cnic == null &&
                result.value!.phoneNumber == null) {
                  print("******************************GoogleAuthCnicPhoneState**********************");
              emit(GoogleAuthCnicPhoneState(user: result.value!));
              return;
            }
            emit(AuthLoadingSuccess(user: result.value!));
          }
        }
      } catch (e) {
        debugPrint(
            "**********************************************************${e.toString()}");
        debugPrint("Stack trace: ${StackTrace.current}");
        emit(GoogleAuthFailed());
      }
    });

    on<GoogleAuthCnicPhoneRequired>((event, emit) async {
      emit(AuthLoading());
      try {
        Result<User, String> user =
            await authentication.submitCnicAndPhoneNumber(event.user);
        if (user.isFailure) {
          emit(AuthError());
        } else {
          emit(AuthLoadingSuccess(user: user.value!));
        }
      } catch (e) {
        debugPrint("Auth Error: $e");
        emit(AuthError());
      }
    });

    on<AuthCredentialsRequired>((event, emit){
      emit(AuthCredentialsState());
    });
  }
}
