import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzizz_clone/view_models/main_page/collection_view_model.dart';
import 'package:quizzizz_clone/views/main_page/collection_form.dart';
import 'package:quizzizz_clone/views/main_page/collection_item.dart';
import 'package:quizzizz_clone/views/quiz_page/quiz_page.dart'; // make sure this exists

class CollectionList extends StatelessWidget {
  const CollectionList({super.key});

  void openForm(BuildContext context, {Map? collection}) async {
    final result = await showDialog(
      context: context,
      builder: (_) => CollectionForm(collection: collection),
    );
    if (result != null) {
      Provider.of<CollectionsViewModel>(context, listen: false).loadCollections();
    }
  }

  void openQuiz(BuildContext context, String collectionId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPage(collectionId: collectionId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionsViewModel>(
      builder: (context, vm, child) {
        if (vm.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.collections.isEmpty) {
          return const Center(child: Text("No collections found."));
        }

        return ListView.builder(
          itemCount: vm.collections.length,
          itemBuilder: (_, index) {
            final item = vm.collections[index];
            return CollectionItem(
              collection: item,
              onEdit: () => openForm(context, collection: item),
              onDelete: () async {
                await vm.deleteCollection(item['id']);
                vm.loadCollections(); // refresh after deletion
              },
              onTap: item['canRead'] == true
                  ? () => openQuiz(context, item['id'])
                  : null, // open quiz only if readable
            );
          },
        );
      },
    );
  }
}
