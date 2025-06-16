import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'item_order_event.dart';
part 'item_order_state.dart';

class ItemOrderBloc extends Bloc<ItemOrderEvent, ItemOrderState> {
  final OrderAndPaymentImp orderAndPaymentImp;
  ItemOrderBloc({required this.orderAndPaymentImp})
      : super(ItemOrderInitial()) {
    on<ItemOrderCreateEvent>((event, emit) async {
      emit(ItemOrderLoading());
      try {
        final Result result = await orderAndPaymentImp.createOrder({
          'itemId': event.item.itemId,
          'borrowerId': event.user.userId,
          'lenderId' : event.item.userId,
          'paymentMethod': event.paymentMethod,
          'borrowDate': DateTime.now().toIso8601String(),
          'requestStatus': 'Pending',
          'returnDate': event.returnDate,
          'accountId':event.user.accountId
        });
        if (result.isFailure) {
          print(result.error!);
          emit(ItemOrderError(error: result.error));
        } else if (result.isSuccess) {
          emit(ItemOrderSuccess(success: result.value));
        }
      } catch (e) {
        emit(ItemOrderError(error: "An unexpected error has occured $e"));
      }
    });

    on<ItemOrderPaymentEvent>((event, emit) async {
      emit(ItemOrderLoading());
      try {
        final Result<bool, String> result = await orderAndPaymentImp.updateBorrowedItem(event.itemDoc);
        if (result.isFailure) {
          emit(ItemOrderError(error: result.error!));
        } else if (result.isSuccess) {
          emit(ItemOrderSuccess(success: result.value??true?"Payment successful":"Payment successful"));
        }
      } catch (e) {
        emit(ItemOrderError(error: "An unexpected error has occured $e"));
      }
    });
  }
}
