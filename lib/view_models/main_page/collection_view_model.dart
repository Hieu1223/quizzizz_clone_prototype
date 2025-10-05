import 'package:flutter/material.dart';
import 'package:quizzizz_clone/service/collection_api.dart';

class CollectionsViewModel extends ChangeNotifier {
  List<dynamic> collections = [];
  bool loading = false;

  Future<void> loadCollections() async {
    loading = true;
    notifyListeners();

    try {
      collections = await CollectionApiService.getMyCollections();
    } catch (e) {
      collections = [];
      print("Error loading collections: $e");
    }

    loading = false;
    notifyListeners();
  }

  Future<void> addCollection(Map<String, dynamic> data) async {
    await CollectionApiService.createCollection(data);
    await loadCollections(); // reload after adding
  }

  Future<void> deleteCollection(String id) async {
    try {
      await CollectionApiService.deleteCollection(id);
      await loadCollections(); // reload after deleting
    } catch (e) {
      print("Error deleting collection: $e");
    }
  }
}
