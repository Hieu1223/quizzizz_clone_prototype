import 'package:flutter/material.dart';
import 'package:quizzizz_clone/service/collection_api.dart';

class CollectionForm extends StatefulWidget {
  final Map? collection;
  const CollectionForm({super.key, this.collection});

  @override
  State<CollectionForm> createState() => _CollectionFormState();
}

class _CollectionFormState extends State<CollectionForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descController;
  bool isPublic = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.collection?['name'] ?? '');
    descController = TextEditingController(text: widget.collection?['description'] ?? '');
    isPublic = widget.collection?['public'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.collection == null ? 'Add Collection' : 'Edit Collection'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextFormField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
            SwitchListTile(
              title: const Text('Public'),
              value: isPublic,
              onChanged: (v) => setState(() => isPublic = v),
            )
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final data = {'name': nameController.text, 'description': descController.text, 'is_public': isPublic};
              if (widget.collection == null) {
                await CollectionApiService.createCollection(data);
              } else {
                await CollectionApiService.updateCollection(widget.collection!['id'], data);
              }
              Navigator.pop(context, true);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
