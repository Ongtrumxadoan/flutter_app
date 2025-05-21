import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ExportService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  Future<void> exportPDF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/export_pdf'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Lưu file PDF (cần xử lý lưu file trên thiết bị)
      print('PDF downloaded successfully');
    } else {
      throw Exception('Failed to export PDF');
    }
  }

  Future<void> exportExcel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/export_excel'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Lưu file Excel (cần xử lý lưu file trên thiết bị)
      print('Excel downloaded successfully');
    } else {
      throw Exception('Failed to export Excel');
    }
  }
}
