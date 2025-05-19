part of 'item_order_bloc.dart';

sealed class ItemOrderEvent extends Equatable {
  const ItemOrderEvent();

  @override
  List<Object> get props => [];
}

class ItemOrderCreateEvent extends ItemOrderEvent{
  final Item item;
  final User user;
  final String paymentMethod;
  final String returnDate;
  const ItemOrderCreateEvent({required this.item, required this.user, required this.paymentMethod, required this.returnDate});
  @override
  List<Object> get props => [item, user, paymentMethod, returnDate];
}


class ItemOrderPaymentEvent extends ItemOrderEvent{
  final Map<String, dynamic> itemDoc;
  const ItemOrderPaymentEvent({required this.itemDoc});
  @override
  List<Object> get props => [itemDoc];
}
