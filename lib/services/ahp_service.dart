import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AHPService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  Future<Map<String, dynamic>> computeAHP(
    List<List<double>> options,
    List<double> weights,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/combined_input'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'options': options, 'weights': weights}),
    );

    return jsonDecode(response.body);
  }

  Future<List<String>> getMatrixHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/matrix-history'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load matrix history');
    }
  }
}
