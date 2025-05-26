import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/borrowing_process_bloc/borrowing_process_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_request_order_bloc/item_request_order_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/wishlist_bloc/wishlist_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/your_items_bloc/your_items_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_order_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_request_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/wishtlist_items.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/your_items_page.dart';
import 'package:next_gen_ai_healthcare/pages/settings/settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final User user =
        (context.read<AuthBloc>().state as AuthLoadingSuccess).user;
    final String name = user.userName;
    String initials = name
        .trim()
        .split(" ")
        .map((e) => e.isNotEmpty ? e[0] : "")
        .join()
        .toUpperCase();

    initials = initials.length >= 2 ? initials.substring(0, 2) : initials;
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  initials,
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(user.email),
                ],
              ),
              // Text(user.location.toString()), //TODO: Do something about it
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0,
        ),
        const SizedBox(
          height: 10,
        ),

        ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) => ItemRequestOrderBloc(
                          orderAndPaymentImp: OrderAndPaymentImp())),
                  BlocProvider(
                    create: (context) => BorrowingProcessBloc(
                      orderAndPaymentImp: OrderAndPaymentImp(),
                    ),
                  ),
                ],
                child: ItemOrderPage(
                  user: user,
                ),
              );
            }));
          },
          leading: CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.onSecondaryFixedVariant,
              child: FaIcon(
                FontAwesomeIcons.truckFast,
                color: Theme.of(context).primaryColor,
              )),
          title: const Text("Orders"),
          subtitle: const Text("Track your orders here"),
          trailing: const FaIcon(Icons.arrow_forward_ios_outlined),
        ),

        // ListTile(
        //   onTap: () {},
        //   leading: const FaIcon(Icons.outbox),
        //   title: const Text("Your Order"),
        //   trailing: const FaIcon(Icons.arrow_forward_ios_outlined),
        // ),

        ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) => ItemRequestOrderBloc(
                              orderAndPaymentImp: OrderAndPaymentImp()),
                          child: ItemRequestPage(
                            user: user,
                          ),
                        )));
          },
          leading: CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.onSecondaryFixedVariant,
              child: FaIcon(
                FontAwesomeIcons.clipboard,
                color: Theme.of(context).primaryColor,
              )),
          title: const Text("Requests"),
          subtitle: const Text("Watch out for customer requests"),
          trailing: const FaIcon(Icons.arrow_forward_ios_outlined),
        ),

        // ListTile(
        //   onTap: () {},
        //   leading: const FaIcon(Icons.history),
        //   title: const Text("History"),

        //   trailing: const FaIcon(Icons.arrow_forward_ios_outlined),
        // ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) =>
                              YourItemsBloc(itemImp: RetrieveDataImp()),
                          child: YourItemsPage(user: user),
                        )));
          },
          leading: CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.onSecondaryFixedVariant,
              child: FaIcon(
                FontAwesomeIcons.stethoscope,
                color: Theme.of(context).primaryColor,
              )),
          title: const Text("Your shop"),
          subtitle: const Text("Manage you equipments here"),
          trailing: const FaIcon(Icons.arrow_forward_ios_outlined),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) =>
                              WishlistBloc(wishlistOps: WishlistOps()),
                          child: WishtlistItems(user: user),
                        )));
          },
          leading: CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.onSecondaryFixedVariant,
              child: FaIcon(
                Icons.favorite_outline_outlined,
                color: Theme.of(context).primaryColor,
              )),
          title: const Text("Favoutires"),
          subtitle: const Text("View and manage your favourite items"),
          trailing: const FaIcon(Icons.arrow_forward_ios_outlined),
        ),

        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage(user: user,)));
          },
          leading: CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.onSecondaryFixedVariant,
              child: FaIcon(
                FontAwesomeIcons.sliders,
                color: Theme.of(context).primaryColor,
              )),
          title: const Text("Settings"),
          subtitle: const Text("App preferences and account settings"),
          trailing: const FaIcon(Icons.arrow_forward_ios_outlined),
        ),
      ]),
    );
  }
}
