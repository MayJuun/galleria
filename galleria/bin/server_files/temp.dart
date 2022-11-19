import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> main() async {
  final result = await http.post(
      Uri.parse('https://doraemon-mctbmzb4uq-uc.a.run.app/create_user'),
      headers: {'Content-Type': "application/json"},
      body: jsonEncode({
        "email": "spitefuljellyfishtrifle@gmail.com",
        "password": "8qhSBfPiuEHhfp7gq3L"
      }));
  print(result.headers);
  print(result.body);
}
