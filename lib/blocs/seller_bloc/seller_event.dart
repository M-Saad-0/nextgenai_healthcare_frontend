part of 'seller_bloc.dart';

sealed class SellerEvent extends Equatable {
  const SellerEvent();

  @override
  List<Object> get props => [];
}

class SellerGetNameImageEvent extends SellerEvent {
    final String userId;
   const SellerGetNameImageEvent({required this.userId});
   @override
   List<Object> get props => [userId];
}