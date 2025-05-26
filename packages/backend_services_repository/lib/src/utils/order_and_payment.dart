import 'package:backend_services_repository/backend_service_repositoy.dart';

abstract class OrderAndPayment {
  Future<Result<String, String>> paymentOperation(String selectedPaymentOption);
  Future<Result<String, String>> createOrder(Map<String, dynamic> orderedItem);
  Future<Result<String, String>> getItemsUserOrdered(User user);
  Future<Result<String, String>> getOrderRequest(User user);
  Future<Result<String, String>> paymentGateway(Map<String, dynamic> itemBorrowed);


  Future<Result<bool, String>> payForTheRequest(); //Borrower
  Future<Result<bool, String>> updateBorrowedItem(Map<String, dynamic> borrowedItem); //Borrower

}