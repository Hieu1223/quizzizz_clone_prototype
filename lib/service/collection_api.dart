import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class CollectionApiService {
  static const baseUrl = "https://flashcard-app-backend-dw04.onrender.com/collections";

  // Get current Firebase ID token
  static Future<String?> getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final token = await user.getIdToken();
    return token;
  }

  // GET all public collections (search)
  static Future<List<dynamic>> searchCollections({String q = ''}) async {
    final uri = Uri.parse('$baseUrl/search?q=$q');
    final res = await http.get(uri);
    return jsonDecode(res.body) as List<dynamic>;
  }

  // GET collections for the current user
  static Future<List<dynamic>> getMyCollections() async {
    final token = await getToken();
    final uri = Uri.parse('$baseUrl/my');
    final res = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final data = jsonDecode(res.body) as List<dynamic>;
    print(data);
    return data;
  }

  // GET single collection by ID
  static Future<Map<String, dynamic>> getCollection(String id) async {
    final token = await getToken();
    final res = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // GET aggregate cards of a collection
  static Future<List<dynamic>> getAggregate(
    String collectionId, {
    int limit = 10,
    int offset = 0,
  }) async {
    final token = await getToken();
    final uri = Uri.parse(
      '$baseUrl/$collectionId/aggregate?limit=$limit&offset=$offset',
    );
    final res = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return jsonDecode(res.body) as List<dynamic>;
  }

  // POST create a new collection
  static Future<Map<String, dynamic>> createCollection(
    Map<String, dynamic> data,
  ) async {
    final token = await getToken();
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );

    final decoded = jsonDecode(res.body);
    // if backend returns an array of 1 item
    return (decoded as List<dynamic>)[0] as Map<String, dynamic>;
  }

  // PUT update an existing collection
  static Future<Map<String, dynamic>> updateCollection(
    String id,
    Map<String, dynamic> data,
  ) async {
    final token = await getToken();
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"data": data}),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // DELETE a collection
  static Future<void> deleteCollection(String id) async {
    final token = await getToken();
    await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // send token in header
      },
    );
  }
}
