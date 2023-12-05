import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:deisi66/main.dart';

Future<String> fetchUserRole() async {
  final url = Uri.parse('http://localhost:5000/getRole');
  final token = getToken();

  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "token": token,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['success'] == true) {
      setRole(data['role']);
      return data['role'] as String;
    }
  }

  throw Exception('Failed to load user role');
}
