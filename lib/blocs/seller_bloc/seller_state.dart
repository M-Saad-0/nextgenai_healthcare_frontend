part of 'seller_bloc.dart';

sealed class SellerState extends Equatable {
  const SellerState();
  
  @override
  List<Object> get props => [];
}

final class SellerInitial extends SellerState {}
final class SellerLoadingState extends SellerState {}
final class SellerErrorState extends SellerState {
  final String err;
  const SellerErrorState({required this.err});
  @override
  List<Object> get props => [err];
}
final class SellerSuccessState extends SellerState {
    final String sellerName;
  final String image;
   const SellerSuccessState({required this.sellerName, required this.image});
   @override
   List<Object> get props => [sellerName, image];
}
