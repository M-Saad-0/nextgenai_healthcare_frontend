part of 'item_bloc.dart';

sealed class ItemState extends Equatable {
  const ItemState();
  
  @override
  List<Object> get props => [];
}

final class ItemInitial extends ItemState {}
final class ItemLoadingState extends ItemState {}
final class ItemSuccessState extends ItemState {
  final List<Item> items;
  const ItemSuccessState({required this.items});
    @override
  List<Object> get props => [items];
}
final class ItemErrorState extends ItemState {
  final String error;
  const ItemErrorState({required this.error});
  @override 
  List<Object> get props => [error];
}

