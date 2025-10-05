import 'dart:convert';
import 'package:http/http.dart' as http;

class TemplateService {
  static const String baseUrl = "https://flashcard-app-backend-dw04.onrender.com/templates";

  // Fetch all templates with optional pagination
  static Future<List<Map<String, dynamic>>> getTemplates({int limit = 50, int offset = 0}) async {
    final uri = Uri.parse('$baseUrl?limit=$limit&offset=$offset');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch templates: ${res.statusCode}');
    }
  }

  // Fetch a single template by ID
  static Future<Map<String, dynamic>> getTemplate(String templateId) async {
    final uri = Uri.parse('$baseUrl/$templateId');
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch template: ${res.statusCode}');
    }
  }

  // Add a new template
  static Future<Map<String, dynamic>> addTemplate({
    required String name,
    required Map<String, dynamic> data,
  }) async {
    final uri = Uri.parse(baseUrl);
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'data': data}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to add template: ${res.statusCode} ${res.body}');
    }
  }
}
