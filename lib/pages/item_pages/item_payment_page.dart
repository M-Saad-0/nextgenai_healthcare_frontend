import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_order_bloc/item_order_bloc.dart';

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
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(context).pop(); // Go back
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
                Text(
                  "Choose Payment Method:",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
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
                RadioListTile(
                  title: const Text("Stripe"),
                  secondary: const Icon(Icons.credit_card),
                  value: "Stripe",
                  groupValue: selectedPaymentOption,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentOption = value!;
                    });
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if(selectedPaymentOption=="Stripe"){
                      
                    }
                    BlocProvider.of<ItemOrderBloc>(context).add(
                      ItemOrderPaymentEvent(
                       itemDoc: widget.itemDoc
                      ),
                    );
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
}
