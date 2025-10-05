import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:quizzizz_clone/view_models/main_page/collection_view_model.dart';
import 'package:quizzizz_clone/views/main_page/collection_form.dart';
import 'package:quizzizz_clone/views/main_page/collection_list.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Welcome, ${user?.email ?? user?.uid ?? "User"}!',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
            child: CollectionList(), // <-- listens to provider
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const CollectionForm(),
            ).then((_) {
              // Tell the view model to reload
              context.read<CollectionsViewModel>().loadCollections();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
