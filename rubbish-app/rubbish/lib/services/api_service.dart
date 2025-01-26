import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://100.120.180.89:5000";

  Future<List<int>> getIntegers() async {
    final url = Uri.parse('$baseUrl/get-integers');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return List<int>.from(data['integers']);
    } else {
      throw Exception('Failed to load integers');
    }
  }

  Future<void> setBooleans(List<bool> booleans) async {
    final url = Uri.parse('$baseUrl/set-booleans');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'booleans': booleans}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update booleans');
    }
  }
}
