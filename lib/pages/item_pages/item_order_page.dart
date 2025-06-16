import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/borrowing_process_bloc/borrowing_process_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_order_bloc/item_order_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_request_order_bloc/item_request_order_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/review_bloc/review_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/error_pages/error_page.dart';
import 'package:next_gen_ai_healthcare/pages/error_pages/not_found_page_.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_payment_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/location_map_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/review_item.dart';

class ItemOrderPage extends StatefulWidget {
  const ItemOrderPage({super.key});

  @override
  State<ItemOrderPage> createState() => _ItemOrderPageState();
}

class _ItemOrderPageState extends State<ItemOrderPage> {
  late User user;
  @override
  void initState() {
    user = (context.read<AuthBloc>().state as AuthLoadingSuccess).user;
    _loadItems();
    super.initState();
  }

  void _loadItems() async {
    BlocProvider.of<ItemRequestOrderBloc>(context)
        .add(ItemOrderRequired(user: user));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Your order"),
        ),
        body: BlocBuilder<ItemRequestOrderBloc, ItemRequestOrderState>(
            builder: (context, state) {
          switch (state) {
            case ItemRequestOrderInitial():
              return const SizedBox();
            case ItemRequestOrderLoading():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ItemRequestOrderError():
              return const NotFoundPage(thing: "Orders", icon: Icons.production_quantity_limits_sharp,);
            case ItemRequestOrderSuccess():
              {
                return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      final itemDocs = state.itemDocs[index];
                      final Color color = itemDocs['requestStatus'] == "Pending"
                          ? Colors.yellowAccent
                          : itemDocs['requestStatus'] == "Rejected"
                              ? Colors.redAccent
                              : Colors.greenAccent;
                      return BlocBuilder<BorrowingProcessBloc,
                          BorrowingProcessState>(
                        builder: (context, requestStatusState) {
                          String requestStatus = itemDocs['requestStatus'];
                          if (requestStatusState
                              is BorrowingProcessSuccessState) {
                            requestStatus = requestStatusState
                                .borrowedItem['requestStatus'];
                          }
                          return Card(
                            child: ListTile(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return LocationMapPage(
                                          role: "borrower",
                                            itemDocs:
                                                itemDocs,
                                            user: user,
                                            item: state.items[index]);
                                      });
                                },
                                title: Text(item.itemName),
                                subtitle: Text("${item.price} RS\t\t${itemDocs['paymentMethod']=="dynamic"?"":itemDocs['paymentMethod']}"), 
                                leading:
                                    Image(image: NetworkImage(item.images[0])),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    (requestStatusState
                                            is BorrowingProcessSuccessState)
                                        ? Text(
                                            requestStatusState
                                                .borrowedItem['requestStatus'],
                                            style: TextStyle(color: color),
                                          )
                                        : Text(
                                            itemDocs['requestStatus'],
                                            style: TextStyle(color: color),
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    requestStatus ==
                                            RequestStatuses.Pending.name
                                        ? const SizedBox()
                                        : requestStatus ==
                                                RequestStatuses.Accepted.name
                                            ? PopupMenuButton(
                                                itemBuilder: (context) {
                                                return <PopupMenuItem>[
                                                  PopupMenuItem(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BlocProvider(
                                                                          create: (context) =>
                                                                              ItemOrderBloc(orderAndPaymentImp: OrderAndPaymentImp()),
                                                                          child: ItemPaymentPage(
                                                                              itemDoc: itemDocs,
                                                                              item: item),
                                                                        )));
                                                      },
                                                      child: const Row(
                                                        children: [
                                                          Icon(Icons.check),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text("Pay")
                                                        ],
                                                      )),
                                                ];
                                              })
                                            : requestStatus ==
                                                    RequestStatuses
                                                        .Completed.name
                                                ? PopupMenuButton(
                                                    itemBuilder: (context) {
                                                    return <PopupMenuItem>[
                                                      PopupMenuItem(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    BorrowingProcessBloc>()
                                                                .add(BorrowingProcessActionEvent(
                                                                    itemBorrowed:
                                                                        itemDocs,
                                                                    newRequestStatus:
                                                                        RequestStatuses
                                                                            .Returing
                                                                            .name));
                                                          },
                                                          child: const Row(
                                                            children: [
                                                              Icon(Icons.check),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text("Return")
                                                            ],
                                                          )),
                                                    ];
                                                  })
                                                : requestStatus ==
                                                        RequestStatuses
                                                            .Returned.name
                                                    ? PopupMenuButton(
                                                        itemBuilder: (context) {
                                                        return <PopupMenuItem>[
                                                          PopupMenuItem(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) {
                                                                  return BlocProvider(
                                                                    create: (context) =>
                                                                        ReviewBloc(
                                                                            reviewOps:
                                                                                ReviewOps()),
                                                                    child:
                                                                        ReviewItemPage(
                                                                      itemBorrowed:
                                                                          itemDocs,
                                                                    ),
                                                                  );
                                                                }));
                                                              },
                                                              child: const Row(
                                                                children: [
                                                                  Icon(Icons
                                                                      .reviews),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                      "Leave a review")
                                                                ],
                                                              )),
                                                        ];
                                                      })
                                                    : const SizedBox()
                                  ],
                                )),
                          );
                        },
                      );
                    });
              }
          }
        }));
  }
}

enum RequestStatuses {
  // ignore: constant_identifier_names
  Accepted,
  // ignore: constant_identifier_names
  Rejected,
  // ignore: constant_identifier_names
  Pending,
  // ignore: constant_identifier_names
  Completed,
  // ignore: constant_identifier_names
  Returing,
  // ignore: constant_identifier_names
  Returned,
  // ignore: constant_identifier_names
  Reviewed
}
