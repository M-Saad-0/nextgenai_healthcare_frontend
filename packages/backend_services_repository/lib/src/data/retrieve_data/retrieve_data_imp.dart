import 'dart:convert';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:backend_services_repository/src/models/item/entities/entities.dart';
import 'package:backend_services_repository/src/models/user/entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RetrieveDataImp extends RetrieveData {
  @override
  Future<Result<List<Item>, String>> getItemsNearMe(
      {Map<String, dynamic> userLocation = const {}, int setNo = 1}) async {
    try {
      Uri url = Uri.parse("$api/items");
      debugPrint("Fetching items from $url");

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        debugPrint("Parsed response: $responseBody");

        List<Item> items = (responseBody as List)
            .map((e) => Item.fromEntity(ItemEntity.fromJson(e)))
            .toList();
        return Result.success(items);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final error =
            json.decode(response.body)['message'] ?? "Failed to load data";
        return Result.failure(error);
      } else {
        return Result.failure("An unexpected error has occurred");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return Result.failure("An error occurred: $e");
    }
  }

  @override
  Future<Result<List<Item>, String>> searchItemsNearMe(
      {Map<String, dynamic> userLocation = const {},
      required String searchTerm}) async {
    Uri uri = Uri.parse(
        "$api/items/query?search=$searchTerm&latitude=${userLocation['coordinates'][1]}&longitude=${userLocation['coordinates'][0]}");
    debugPrint("Searching items from $uri");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List;
        final searchedItems = jsonResponse
            .map((e) => Item.fromEntity(ItemEntity.fromJson(e)))
            .toList();
        return Result.success(searchedItems);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final error = json.decode(response.body)['message'] ??
            "Could not find $searchTerm";
        return Result.failure(error);
      } else {
        print("JSON RESPONSE: ${response.body}");
        return Result.failure("An unexpected error occurred");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return Result.failure("An error occurred: $e");
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>, String>> getItemReviews(
      {required String itemId}) async {
    Uri uri = Uri.parse("$api/item-reviews/$itemId");
    debugPrint("Fetching reviews from $uri");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List;
        return Result.success(jsonResponse.cast<Map<String, dynamic>>());
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final error = json.decode(response.body)['message'] ??
            "Could not find reviews for item $itemId";
        return Result.failure(error);
      } else {
        return Result.failure("An unexpected error occurred");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return Result.failure("An error occurred: $e");
    }
  }

  @override
  Future<Result<List<Item>, String>> getItemsByUser(
      {required String userId}) async {
    Uri uri = Uri.parse("$api/items/userItems/$userId");
    debugPrint("Fetching items from $uri");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List;
        final items = jsonResponse
            .map((e) => Item.fromEntity(ItemEntity.fromJson(e)))
            .toList();
        return Result.success(items);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final error = json.decode(response.body)['message'] ??
            "Could not find items for user $userId";
        return Result.failure(error);
      } else {
        return Result.failure("An unexpected error occurred");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return Result.failure("An error occurred: $e");
    }
  }

  @override
  Future<Result<User, String>> getUserById({required String userId}) async {
    Uri uri = Uri.parse("$api/users/$userId");
    debugPrint("Fetching user from $uri");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Result.success(
            User.fromEntity(UserEntity.fromJson(jsonResponse)));
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final error = json.decode(response.body)['message'] ??
            "Could not find user with ID $userId";
        return Result.failure(error);
      } else {
        return Result.failure("An unexpected error occurred");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return Result.failure("An error occurred: $e");
    }
  }

  @override
  Future<Result<bool, String>> deleteItem({required String itemId}) async {
    try {
      final response = await http.delete(
        Uri.parse("$api/items/$itemId"),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 204) {
        return Result.success(jsonDecode(response.body)['message']=="item deleted");
      } else if (response.statusCode == 404) {
        return Result.failure("The item does not exist");
      } else if (response.statusCode == 403) {
        return Result.failure("You do not have access for this");
      } else {
        return Result.failure("Failed to delete the item. Unexpected error.");
      }
    } catch (e) {
      debugPrint("Error occurred: ${e.toString()}");
      return Result.failure("An error occurred: ${e.toString()}");
    }
  }

  @override
  Future<Result<bool, String>> updateItem(
      {required itemId, required Item item}) async {
    try {
      final response = await http.put(Uri.parse("$api/items/$itemId"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(ItemEntity.toJson(Item.toEntity(item))));
      if (response.statusCode == 200) {
        return Result.success(jsonDecode(response.body)['message']);
      } else if (response.statusCode == 404) {
        return Result.failure("The item does not exist");
      } else if (response.statusCode == 403) {
        return Result.failure("You do not have access for this");
      } else {
        return Result.failure("Failed to update the item. Unexpected error.");
      }
    } catch (e) {
      debugPrint("Error occurred: ${e.toString()}");
      return Result.failure("An error occurred: ${e.toString()}");
    }
  }


  @override
  Future<Result<List<Item>, String>> getSpecificNumberOfItems(
      {required int itemCount, required Map<String, dynamic> location}) async {
    try {
      final uri = Uri.parse(
            "$api/items/itemCount?itemno=$itemCount&latitude=${location['coordinates'][1]}&longitude=${location['coordinates'][0]}");
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        print("Response body: ${response.body}");
        final jsonResponse = json.decode(response.body)['items'] as List;
        final items = jsonResponse
            .map((e) => Item.fromEntity(ItemEntity.fromJson(e)))
            .toList();
        return Result.success(items);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final error =
            json.decode(response.body)['message'] ?? "Could not find items";
        return Result.failure(error);
      } else {
        print(response.body);
        return Result.failure("An unexpected error occurred");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return Result.failure("An error occurred: $e");
    }
  }
}

// TODO: Please implement the borrowing feature
// If the borrower could request to borrow first
// And then if lender accepts the request he will lend
