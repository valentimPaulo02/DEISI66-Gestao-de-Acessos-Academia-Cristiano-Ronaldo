import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:deisi66/main.dart';

Future<void> fetchUserRole(String token) async {
  final url = Uri.parse('https://projects.deisi.ulusofona.pt/DEISI66/getRole');

  final response = await http
      .get(url, headers: {"Content-Type": "application/json", "token": token});

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['success'] == true) {
      setRole(data['role']);
      setToken(token);
    }
  } else {
    throw Exception('Failed to load user role');
  }
}
