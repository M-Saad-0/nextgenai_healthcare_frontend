// import 'package:backend_services_repository/backend_service_repositoy.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
// import 'package:next_gen_ai_healthcare/blocs/item_order_bloc/item_order_bloc.dart';
// import 'package:next_gen_ai_healthcare/constants/api_key.dart';
// import 'package:next_gen_ai_healthcare/pages/item_pages/item_order_page.dart';
// import 'package:next_gen_ai_healthcare/widgets/show_toast.dart';

// class ItemPaymentPage extends StatefulWidget {
//   final Item item;
//   final Map<String, dynamic> itemDoc;

//   const ItemPaymentPage({super.key, required this.item, required this.itemDoc});

//   @override
//   State<ItemPaymentPage> createState() => _ItemPaymentPageState();
// }

// class _ItemPaymentPageState extends State<ItemPaymentPage> {
//   String selectedPaymentOption = "Cash on delivery";
//   Map<String, dynamic>? intentPaymentData;

//   @override
//   Widget build(BuildContext context) {
//     final User user =
//         (context.read<AuthBloc>().state as AuthLoadingSuccess).user;

//     return Scaffold(
//       appBar: AppBar(title: Text("Payment for ${widget.item.itemName}")),
//       body: BlocConsumer<ItemOrderBloc, ItemOrderState>(
//         listener: (context, state) {
//           if (state is ItemOrderSuccess) {
//             showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (context) {
//                 return AlertDialog(
//                   title: const Text("Order successful"),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.check_circle_outline_outlined,
//                           color: Colors.greenAccent, size: 40),
//                       const SizedBox(height: 10),
//                       Text(state.success),
//                     ],
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop(); // Close dialog
//                         Navigator.of(context).pop(); // Go back
//                       },
//                       child: const Text("Close"),
//                     ),
//                   ],
//                 );
//               },
//             );
//           } else if (state is ItemOrderError) {
//             showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: const Text("Order failed"),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.error,
//                           color: Colors.redAccent, size: 40),
//                       const SizedBox(height: 10),
//                       Text(state.error),
//                     ],
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: const Text("Close"),
//                     ),
//                   ],
//                 );
//               },
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is ItemOrderLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Text(
//                   "Choose Payment Method:",
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 const SizedBox(height: 16),
//                 RadioListTile(
//                   title: const Text("Cash on delivery"),
//                   secondary: const Icon(Icons.handshake),
//                   value: "Cash on delivery",
//                   groupValue: selectedPaymentOption,
//                   onChanged: (value) {
//                     setState(() {
//                       selectedPaymentOption = value!;
//                     });
//                   },
//                 ),
//                 RadioListTile(
//                   title: const Text("Stripe"),
//                   secondary: const Icon(Icons.credit_card),
//                   value: "Stripe",
//                   groupValue: selectedPaymentOption,
//                   onChanged: (value) {
//                     setState(() {
//                       selectedPaymentOption = value!;
//                     });
//                   },
//                 ),
//                 const Spacer(),
//                 ElevatedButton(
//                   onPressed: () async {
//                         final newItemDoc = widget.itemDoc;
//                         newItemDoc['paymentMethod'] = selectedPaymentOption;
//                     bool isSuccess = false;
//                     if (selectedPaymentOption == "Stripe") {
//                       isSuccess = await paymentSheetInitialiations(
//                           widget.item.price, "PKR");
//                       if (isSuccess) {
//                         newItemDoc['requestStatus'] = RequestStatuses.Completed.name;
//                         BlocProvider.of<ItemOrderBloc>(context).add(
//                           ItemOrderPaymentEvent(itemDoc: newItemDoc),
//                         );
//                       } else {
//                         showToastMessage("Payment Failed");
//                       }
//                     }else{
//                        BlocProvider.of<ItemOrderBloc>(context).add(
//                           ItemOrderPaymentEvent(itemDoc: newItemDoc),
//                         );
//                     }

//                   },
//                   child: const Text("Proceed"),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<bool> paymentSheetInitialiations(int amount, String currency) async {
//     try {
//       intentPaymentData = await makeIntentForPayment(amount, currency);
//       await Stripe.instance
//           .initPaymentSheet(
//               paymentSheetParameters: SetupPaymentSheetParameters(
//                   allowsDelayedPaymentMethods: true,
//                   paymentIntentClientSecret:
//                       intentPaymentData!['client_secret'],
//                   style: Theme.of(context).brightness == Brightness.dark
//                       ? ThemeMode.dark
//                       : ThemeMode.light,
//                   merchantDisplayName: "NextGenAI Healthcare"))
//           .then((v) {
//         debugPrint(v.toString());
//       });
//       bool isSuccess = await showPaymentSheet();
//       return isSuccess;
//     } catch (e) {
//       debugPrint(e.toString());
//       return false;
//     }
//   }

//   Future<bool> showPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//       intentPaymentData = null;

//       // Payment succeeded
//       debugPrint("Payment successful");
//       return true;
//     } on StripeException catch (e) {
//       debugPrint("StripeException: ${e.toString()}");

//       await showDialog(
//         context: context,
//         builder: (context) => const AlertDialog(
//           title: Text("Payment Failed"),
//           content: Text("Stripe Payment Failed"),
//         ),
//       );
//       return false;
//     } catch (e) {
//       debugPrint("Unknown error: ${e.toString()}");
//       return false;
//     }
//   }

//   Future<Map<String, dynamic>> makeIntentForPayment(
//       int amount, String currency) async {
//     try {
//       Map<String, dynamic>? paymentJson = {
//         'amount': amount *
//             100 *
//             DateTime.parse(widget.itemDoc['returnDate'])
//                 .difference(DateTime.parse(widget.itemDoc['borrowDate']))
//                 .inHours,
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//       final response = await context
//           .read<ItemOrderBloc>()
//           .orderAndPaymentImp
//           .sendRequestToStripe(
//               paymentJson: paymentJson,
//               publishableKey: publishing_key,
//               secretKey: secret_key);
//       return response;
//     } catch (e) {
//       debugPrint(e.toString());
//       return {};
//     }
//   }
// }

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_order_bloc/item_order_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_order_page.dart';
import 'package:next_gen_ai_healthcare/widgets/show_toast.dart';
import 'dart:convert';

class ItemPaymentPage extends StatefulWidget {
  final Item item;
  final Map<String, dynamic> itemDoc;

  const ItemPaymentPage({super.key, required this.item, required this.itemDoc});

  @override
  State<ItemPaymentPage> createState() => _ItemPaymentPageState();
}

class _ItemPaymentPageState extends State<ItemPaymentPage> {
  String selectedPaymentOption = "Cash on delivery";

  @override
  Widget build(BuildContext context) {
    final User user =
        (context.read<AuthBloc>().state as AuthLoadingSuccess).user;

    return Scaffold(
      appBar: AppBar(title: Text("Payment for ${widget.item.itemName}")),
      body: BlocConsumer<ItemOrderBloc, ItemOrderState>(
        listener: (context, state) {
          if (state is ItemOrderSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Order successful"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline_outlined,
                          color: Colors.greenAccent, size: 40),
                      const SizedBox(height: 10),
                      Text(state.success),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close"),
                    ),
                  ],
                );
              },
            );
          } else if (state is ItemOrderError) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Order failed"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error,
                          color: Colors.redAccent, size: 40),
                      const SizedBox(height: 10),
                      Text(state.error),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close"),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is ItemOrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Text(
                //   "Choose Payment Method:",
                //   style: Theme.of(context).textTheme.headlineSmall,
                // ),
                const SizedBox(height: 16),
                RadioListTile(
                  title: const Text("Cash on delivery"),
                  secondary: const Icon(Icons.handshake),
                  value: "Cash on delivery",
                  groupValue: selectedPaymentOption,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentOption = value!;
                    });
                  },
                ),
                widget.itemDoc['sellerAccountId'] != null
                    ? RadioListTile(
                        title: const Text("Stripe"),
                        secondary: const Icon(Icons.credit_card),
                        value: "Stripe",
                        groupValue: selectedPaymentOption,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentOption = value!;
                          });
                        },
                      )
                    : const SizedBox.shrink(),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final newItemDoc = widget.itemDoc;
                    newItemDoc['paymentMethod'] = selectedPaymentOption;
                    // newItemDoc['sellerAccountId'] = user.accountId;
                    bool isSuccess = false;

                    if (selectedPaymentOption == "Stripe") {
                      isSuccess = await initiateStripePayment();
                      if (isSuccess) {
                        newItemDoc['requestStatus'] =
                            RequestStatuses.Completed.name;
                        BlocProvider.of<ItemOrderBloc>(context).add(
                          ItemOrderPaymentEvent(itemDoc: newItemDoc),
                        );
                      } else {
                        showToastMessage("Payment Failed");
                      }
                    } else {
                      newItemDoc['requestStatus'] =
                          RequestStatuses.Completed.name;

                      BlocProvider.of<ItemOrderBloc>(context).add(
                        ItemOrderPaymentEvent(itemDoc: newItemDoc),
                      );
                    }
                  },
                  child: const Text("Proceed"),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> initiateStripePayment() async {
    try {
      final amount = widget.item.price *
          1 *
          DateTime.parse(widget.itemDoc['returnDate'])
              .difference(DateTime.parse(widget.itemDoc['borrowDate']))
              .inHours;
      final paymentJson = {
        'amount': amount,
        'currency': 'pkr',
        'sellerAccountId': widget.itemDoc['sellerAccountId'],
        'applicationFeeAmount': 100 // optional
      };

      final jsonResponse = await OrderAndPaymentImp()
          .sendRequestToStripe(paymentJson: paymentJson);
      if (!jsonResponse.containsKey('clientSecret')) {
        return false;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['clientSecret'],
          merchantDisplayName: "NextGenAI Healthcare",
          style: Theme.of(context).brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
