import 'dart:convert';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:http/http.dart' as http;

class FcmDatabaseRequest {

  static Future<void> sendTokenToBackend(String? token, String userId) async {
    if (token == null) return;
    final response = await http.post(
      Uri.parse('$api/users/save-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fcmToken': token, 'userId': userId}),
    );
    print(response.body);
  }
}
