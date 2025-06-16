import 'package:backend_services_repository/src/models/item/entities/entities.dart';

class Item {
  final String itemId;
  final String itemName;
  final String description;
  final List<String> images;
  final Map<String, dynamic> location;
  final String seller;
  final int sold;
  final double rating;
  final String userId;
  final bool isRented;
  final int price;
  final int reviews;

  Item({
    required this.itemId,
    required this.itemName,
    required this.description,
    required this.images,
    required this.location,
    required this.seller,
    required this.sold,
    required this.rating,
    required this.userId,
    required this.isRented,
    required this.price,
    this.reviews = 0,
  });

  static ItemEntity toEntity(Item item) {
    return ItemEntity(
        itemId: item.itemId,
        itemName: item.itemName,
        description: item.description,
        images: item.images,
        location: item.location,
        seller: item.seller,
        sold: item.sold,
        rating: item.rating,
        userId: item.userId,
        isRented: item.isRented,
        price: item.price,
        reviews: item.reviews);
  }

  static Item fromEntity(ItemEntity itemEntity) {
    return Item(
        itemId: itemEntity.itemId,
        itemName: itemEntity.itemName,
        description: itemEntity.description,
        images: itemEntity.images,
        location: itemEntity.location,
        seller: itemEntity.seller,
        sold: itemEntity.sold,
        rating: itemEntity.rating,
        userId: itemEntity.userId,
        price: itemEntity.price,
        isRented: itemEntity.isRented,
        reviews: itemEntity.reviews);
        
  }

  Item copyWith(
      {String? itemId,
      String? itemName,
      String? description,
      String? seller,
      List<String>? images,
      Map<String, dynamic>? location,
      int? sold,
      int? reviews,
      bool? isRented,
      int? price,
      double? rating,
      String? userId}) {
    return Item(
        itemId: itemId ?? this.itemId,
        itemName: itemName ?? this.itemName,
        description: description ?? this.description,
        images: images ?? this.images,
        location: location ?? this.location,
        seller: seller ?? this.seller,
        sold: sold ?? this.sold,
        rating: rating ?? this.rating,
        userId: userId ?? this.userId,
        isRented: isRented ?? this.isRented,
        price: price ?? this.price,
        reviews: reviews ?? this.reviews);
  }
}
