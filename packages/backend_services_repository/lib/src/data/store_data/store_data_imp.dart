import 'dart:convert';
import 'dart:io';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class StoreDataImp extends StoreData {
   @override
  Future<Result<String, String>> storeAnItem({required Item item}) async {
    Uri url = Uri.parse("$api/items");

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ItemEntity.toJson(Item.toEntity(item))),
    );

    if (response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      return Result.success(responseBody['status']);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      final responseBody = json.decode(response.body);
      return Result.failure(responseBody['status']);
    } else {
      return Result.failure("An unexpected error occurred");
    }
  }

  @override
  Future<Result<String, String>> createItemObjectInDatabase(
      String userId, Item item) async {
    var request = http.post(
      Uri.parse("$api/items"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ItemEntity.toJson(Item.toEntity(item))),
    );
    var response = await request;
    if (response.statusCode == 201) {
      Map<String, dynamic> itemJson = json.decode(response.body);
      return Result.success(itemJson['_id']);
    } else {
      return Result.failure(json.decode(response.body)['error']['message']);
    }
  }

  @override
  Future<List<String>> getImagesFromPhone() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      return Future.value(images.map<String>((XFile e) => e.path).toList());
    } else {
      return Future.value([]);
    }
  }

  static Future<File> compressAndGetFile(File file) async {
    var tempDir = Directory.systemTemp;
    var targetPath = path.join(tempDir.path,
        "${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}");
    var imagePath = file.absolute.path;
    var result =
        await FlutterImageCompress.compressAndGetFile(imagePath, targetPath, quality: 50);
    return result == null ? File(result!.path) : file;
  }

  @override
  Future<Result<List<String>, String>> uploadToCloudinary(
      List<String> images, String id) async {
    List<List<int>> imagesBytes = await Future.wait(images.map((p) async {
      return await (await compressAndGetFile(File(p))).readAsBytes();
    }).toList());
    List<String> imageUrl = [];
    for (int i = 0; i < images.length; i++) {
      String extension = path.extension(images[i]);
      final request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl))
        ..fields['upload_preset'] = "ml_default"
        ..fields['folder'] = "nextgenmedcare/$id"
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          imagesBytes[i],
          filename: "$i$extension",
        ));
      final responseStream = await request.send();

      if (responseStream.statusCode == 200) {
        final responseBody = await http.Response.fromStream(responseStream);
        final responseJson = json.decode(responseBody.body);
        if (responseJson['secure_url'] == null) {
          debugPrint("Error uploading $id.$extension image");
          return Result.failure("Error uploading $id.$extension image");
        } else {
          debugPrint("Uploaded $id.$extension image");
          imageUrl.add(responseJson['secure_url']);
        }
      } else if (responseStream.statusCode == 201) {
        final responseBody = await http.Response.fromStream(responseStream);
        final responseJson = json.decode(responseBody.body);
        if (responseJson['secure_url'] == null) {
          debugPrint("Error uploading $id.$extension image");
          return Result.failure("Error uploading $id.$extension image");
        } else {
          debugPrint("Uploaded $id.$extension image");
          imageUrl.add(responseJson['secure_url']);
        }
      } else {
        debugPrint("Error uploading $id.$extension image");
        return Result.failure("Error uploading $id.$extension image");
      }
    }
    if (imageUrl.isNotEmpty) {
      return Result.success(imageUrl);
    } else {
      return Result.failure("Error uploading images");
    }
  }
}
