import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/your_items_bloc/your_items_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/error_pages/not_found_page_.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/add_item.dart';
import 'package:next_gen_ai_healthcare/widgets/your_item_widget.dart';

class YourItemsPage extends StatefulWidget {
  final User user;
  const YourItemsPage({super.key, required this.user});

  @override
  State<YourItemsPage> createState() => _YourItemsPageState();
}

class _YourItemsPageState extends State<YourItemsPage> {
  List<String> selectedItemId = [];

  @override
  void initState() {
    super.initState();
    context.read<YourItemsBloc>().add(YourItemsLoadEvent(userId: widget.user.userId));
  }

  void _refreshItems() {
    context.read<YourItemsBloc>().add(YourItemsLoadEvent(userId: widget.user.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Items"),
        actions: selectedItemId.isEmpty
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<YourItemsBloc>().add(
                          YourItemsDeleteEvent(itemId: selectedItemId),
                        );
                    setState(() {
                      selectedItemId = [];
                    });
                  },
                ),
                const VerticalDivider(),
                // IconButton(
                //   icon: const Icon(Icons.edit),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => BlocProvider(
                //           create: (_) => CreateItemBloc(storeData: StoreDataImp()),
                //           child: const AddItem(),
                //         ),
                //       ),
                //     );
                //   },
                // ),
                // const VerticalDivider(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      selectedItemId.clear();
                    });
                  },
                ),
              ],
      ),
      body: BlocBuilder<YourItemsBloc, YourItemsState>(
        builder: (context, state) {
          if (state is YourItemsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is YourItemsSuccessState) {
            return RefreshIndicator(
              onRefresh: () async => _refreshItems(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: state.items.isEmpty
                    ? const Center(child: Text("No Items Added Yet!"))
                    : GridView.builder(
                        itemCount: state.items.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return GestureDetector(
                            onLongPress: () {
                              setState(() {
                                selectedItemId.add(item.itemId);
                              });
                            },
                            child: YourItemWidget(
                              title: item.itemName,
                              description: item.description,
                              images: item.images,
                              seller: item.seller,
                              sold: item.sold,
                              rating: item.rating,
                              darkenBackground: selectedItemId.contains(item.itemId),
                            ),
                          );
                        },
                      ),
              ),
            );
          } else if (state is YourItemsErrorState) {
            return RefreshIndicator(
              onRefresh: () async => _refreshItems(),
              child: const NotFoundPage(thing: "Medical Equipments", icon: Icons.medical_services,)
            );
          }
          return const NotFoundPage(thing: "Medical Equipments", icon: Icons.medical_services,);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => CreateItemBloc(storeData: StoreDataImp()),
                child: const AddItem(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
