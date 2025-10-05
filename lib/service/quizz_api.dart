import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class QuizApi {
  static const String baseUrl = "https://flashcard-app-backend-dw04.onrender.com";

  // 🔐 Get Firebase ID token
  static Future<String?> getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  // 📚 Get all quizzes (cards) from a collection
  static Future<List<dynamic>> getQuizzes(
    String collectionId, {
    int limit = 10,
    int offset = 0,
  }) async {
    final token = await getToken();
    final uri = Uri.parse(
      "$baseUrl/collections/$collectionId/aggregate?limit=$limit&offset=$offset",
    );

    final res = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception(
        "Failed to fetch quizzes: ${res.statusCode} ${res.reasonPhrase}",
      );
    }

    final decoded = jsonDecode(res.body);
    if (decoded is List) {
      return decoded;
    } else {
      throw Exception("Unexpected response format: expected List");
    }
  }

  // 🆕 Add a new quiz (card)
  static Future<Map<String, dynamic>> addQuiz({
    required String collectionId,
    required Map<String, dynamic> data,
    bool isPublic = false,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception("User not authenticated");

    final uri = Uri.parse("$baseUrl/cards");

    final body = jsonEncode({
      "collection_id": collectionId,
      "data": data,
      "type": data['type'] ?? 'blank',
      "is_public": isPublic,
    });

    final res = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(
        "Failed to add quiz: ${res.statusCode} ${res.reasonPhrase}",
      );
    }

    final decoded = jsonDecode(res.body);
    if (decoded is List && decoded.isNotEmpty) {
      return decoded[0] as Map<String, dynamic>;
    } else if (decoded is Map<String, dynamic>) {
      return decoded;
    } else {
      throw Exception("Unexpected response format");
    }
  }

  // ✏️ Update an existing quiz (card)
  static Future<Map<String, dynamic>> updateQuiz({
    required String cardId,
    required Map<String, dynamic> data,
    String? type,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception("User not authenticated");

    final uri = Uri.parse("$baseUrl/cards/$cardId");

    final body = {
      "data": data,
      if (type != null) "type": type,
    };

    final res = await http.put(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception(
        "Failed to update quiz: ${res.statusCode} ${res.reasonPhrase}",
      );
    }

    final decoded = jsonDecode(res.body);
    if (decoded is List && decoded.isNotEmpty) {
      return decoded[0] as Map<String, dynamic>;
    } else if (decoded is Map<String, dynamic>) {
      return decoded;
    } else {
      throw Exception("Unexpected response format");
    }
  }

  // ❌ Delete a quiz (card)
  static Future<void> deleteQuiz(String cardId) async {
    final token = await getToken();
    if (token == null) throw Exception("User not authenticated");

    final uri = Uri.parse("$baseUrl/cards/$cardId");

    final res = await http.delete(
      uri,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception(
        "Failed to delete quiz: ${res.statusCode} ${res.reasonPhrase}",
      );
    }
  }

  // 📘 Get a single quiz (card)
  static Future<Map<String, dynamic>> getQuiz(String cardId) async {
    final token = await getToken();
    if (token == null) throw Exception("User not authenticated");

    final uri = Uri.parse("$baseUrl/cards/$cardId");

    final res = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception(
        "Failed to fetch quiz: ${res.statusCode} ${res.reasonPhrase}",
      );
    }

    final decoded = jsonDecode(res.body);
    if (decoded is List && decoded.isNotEmpty) {
      return decoded[0] as Map<String, dynamic>;
    } else if (decoded is Map<String, dynamic>) {
      return decoded;
    } else {
      throw Exception("Unexpected response format");
    }
  }
}
