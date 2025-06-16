import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:latlong2/latlong.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_order_bloc/item_order_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/review_bloc/review_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/seller_bloc/seller_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/wishlist_bloc/wishlist_bloc.dart';
import 'package:next_gen_ai_healthcare/widgets/set_item_duration.dart';
import 'package:next_gen_ai_healthcare/widgets/show_toast.dart';
import 'package:share_plus/share_plus.dart';

class ItemDetailPage extends StatefulWidget {
  final Item item;

  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int reviewSet = 0;
  bool itemAddedToWishList = false;
  @override
  Widget build(BuildContext context) {
    final User user =
        (context.read<AuthBloc>().state as AuthLoadingSuccess).user;
    final LatLng userLatLng = LatLng(
        user.location!['coordinates'][1], user.location!['coordinates'][0]);
    final LatLng itemLatLng = LatLng(widget.item.location['coordinates'][1],
        widget.item.location['coordinates'][0]);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.itemName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: widget.item.images.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Image.network(widget.item.images[index],
                            fit: BoxFit.contain));
                  },
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                  text: TextSpan(
                      text: "Rs ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                      children: [
                    TextSpan(
                        text: widget.item.price.toString(),
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600))
                            ,
                            const TextSpan(text: " per hour", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400))
                  ])),
              const SizedBox(
                height: 10,
              ),
              Text(widget.item.itemName,
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              BlocProvider(
                create: (context) => SellerBloc()
                  ..add(SellerGetNameImageEvent(userId: widget.item.userId)),
                child: BlocBuilder<SellerBloc, SellerState>(
                  builder: (context, state) {
                    switch (state) {
                      case SellerInitial():
                        return const SizedBox();
                      case SellerLoadingState():
                        return const Center(child: LinearProgressIndicator());
                      case SellerErrorState():
                        return Center(child: Text(state.err));
                      case SellerSuccessState():
                        String initials = state.sellerName
                            .trim()
                            .split(" ")
                            .map((e) => e.isNotEmpty ? e[0] : "")
                            .join()
                            .toUpperCase();

                        initials = initials.length >= 2
                            ? initials.substring(0, 2)
                            : initials;
                        final imageUrl = state.image.trim();

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : null,
                              backgroundColor: Colors.grey.shade300,
                              child: imageUrl.isEmpty
                                  ? Text(
                                      initials,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : null,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(state.sellerName)
                          ],
                        );
                    }
                  },
                ),
              ),
              // Text("Seller: ${widget.item.seller}",;
              // style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.item.rating.toStringAsFixed(1),
                    style: const TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 13),
                  ),
                  const VerticalDivider(),
                  Text(
                    "Rented ${widget.item.sold.toString()} times",
                    style: const TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 13),
                  ),
                  const VerticalDivider(),
                  Text(
                    widget.item.isRented ? "Rented" : "Available",
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 13,
                        color:
                            widget.item.isRented ? Colors.red : Colors.green),
                  ),
                  const Spacer(),
                  BlocProvider(
                    create: (context) =>
                        WishlistBloc(wishlistOps: WishlistOps())
                          ..add(WishlistGetCurrentEvent(
                              itemId: widget.item.itemId, userId: user.userId)),
                    child: BlocBuilder<WishlistBloc, WishlistState>(
                        builder: (context, state) {
                      if (state is WishlistCurrentState) {
                        itemAddedToWishList = state.currentState;
                        // print("object");
                      }
                      return StatefulBuilder(builder: (context, setState) {
                        return IconButton(
                            onPressed: () {
                              setState(() {
                                itemAddedToWishList = !itemAddedToWishList;
                              });
                              if (itemAddedToWishList) {
                                context.read<WishlistBloc>().add(
                                    WishlistAddEvent(
                                        itemId: widget.item.itemId,
                                        userId: user.userId));
                              } else if (!itemAddedToWishList) {
                                context.read<WishlistBloc>().add(
                                    WishlistDeleteEvent(
                                        itemId: widget.item.itemId,
                                        userId: user.userId));
                              }
                            },
                            icon: itemAddedToWishList
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border));
                      });
                    }),
                  ),
                  IconButton(
                      onPressed: () {
                        SharePlus.instance.share(ShareParams(
                          title: widget.item.itemName,
                          text:
                              "Check out this item: ${widget.item.itemName} for Rs ${widget.item.price}.\n\nDescription: ${widget.item.description}\n\nFound on Next Gen AI Healthcare app!",
                        ));
                      },
                      icon: const Icon(Icons.share)),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.item.description,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 95,
                height: 150,
                child: FlutterMap(
                  options: MapOptions(initialCenter: itemLatLng),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName:
                          'com.saadc.next_gen_ai_healthcare', // Replace with your package
                    ),
                    MarkerLayer(markers: [
                      Marker(
                        width: 40,
                        height: 40,
                        point: userLatLng,
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                      Marker(
                        width: 40,
                        height: 40,
                        point: itemLatLng,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ])
                  ],
                ),
              ),
              BlocBuilder<ReviewBloc, ReviewState>(builder: (context, state) {
                switch (state) {
                  case ReviewLoading():
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ReviewSuccess():
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.reviewModel.length,
                          itemBuilder: (context, index) {
                             String initials = state.reviewModel[index].renterName
                            .trim()
                            .split(" ")
                            .map((e) => e.isNotEmpty ? e[0] : "")
                            .join()
                            .toUpperCase();

                        initials = initials.length >= 2
                            ? initials.substring(0, 2)
                            : initials;
                            final image = state.reviewModel[index].picture;
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: image.isEmpty
                                              ? null
                                              : NetworkImage(image),
                                          child: image.isEmpty
                                              ? Text(initials)
                                              : null,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.reviewModel[index]
                                                  .renterName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            StarRating(
                                              rating: state.reviewModel[index]
                                                  .personRating,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(state.reviewModel[index].review,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        state.reviewModel.isNotEmpty
                            ? (!state.reviewModel.last.isLastPage
                                ? TextButton(
                                    onPressed: () {
                                      reviewSet++;
                                      context.read<ReviewBloc>().add(
                                          FetchMoreReviewEvent(
                                              itemId: widget.item.itemId,
                                              currentreviews: state.reviewModel,
                                              setNo: reviewSet));
                                    },
                                    child: const Text("Load more reviews"))
                                : const SizedBox.shrink())
                            : const SizedBox.shrink()
                      ],
                    );
                  case ReviewError():
                  default:
                    return const Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text("No Reviews Yet!"),
                        ),
                      ],
                    );
                }
              })
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (context) =>
              ItemOrderBloc(orderAndPaymentImp: OrderAndPaymentImp()),
          child: Builder(builder: (context) {
            return BlocListener<ItemOrderBloc, ItemOrderState>(
              listener: (context, state) {
                if(state is ItemOrderError){
                  debugPrint("********************************************");
                  showToastMessage(state.error);
                }
              },
              child: ElevatedButton(
                onPressed: widget.item.isRented
                    ? () {
                        showToastMessage(
                            "${widget.item.itemName} already rented");
                      }
                    : () async {
                        Map<String, dynamic>? returnDate =
                            await showItemDurationDialog(context);
                        print(returnDate);
                        if (returnDate != null) {
                          context.read<ItemOrderBloc>().add(
                              ItemOrderCreateEvent(
                                  item: widget.item,
                                  user: user,
                                  returnDate: returnDate['returnDate'],
                                  paymentMethod: "dynamic"));
                          showToastMessage("Your request for rent is submitted");
                          
                        }
                      },
                child: const Text("Rent It"),
              ),
            );
          }),
        ),
      ),
    );
  }
}
