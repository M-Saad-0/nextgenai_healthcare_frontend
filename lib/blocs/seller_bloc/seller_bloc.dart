import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'seller_event.dart';
part 'seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  SellerBloc() : super(SellerInitial()) {
    on<SellerGetNameImageEvent>((event, emit)async {
      emit(SellerLoadingState());
      try{
        final result = await ReviewOps.getUserById(userId: event.userId);
        if(result.isFailure){
          emit(SellerErrorState(err: result.error!));
        }else{
          emit(SellerSuccessState(sellerName: result.value!['sellerName'], image: result.value!['image']));
        }
      }catch (e){
        debugPrint(e.toString());
        emit(const SellerErrorState(err: "Some unexpected error occured"));
      }
    });
  }
}
