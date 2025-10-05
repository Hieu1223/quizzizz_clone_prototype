import 'package:flutter/material.dart';

class CollectionItem extends StatelessWidget {
  final Map collection;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap; // optional tap callback for opening quiz

  const CollectionItem({
    super.key,
    required this.collection,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final canRead = collection['canRead'] ?? false;
    final canWrite = collection['canWrite'] ?? false;

    return Opacity(
      opacity: canRead ? 1.0 : 0.5, // grey out if no read permission
      child: Card(
        child: ListTile(
          title: Text(collection['name'] ?? 'Untitled'),
          subtitle: Text(collection['description'] ?? ''),
          onTap: canRead ? onTap : null, // open quiz page if readable
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: canWrite ? onEdit : null,
                tooltip: canWrite ? 'Edit Collection' : 'No write permission',
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: canWrite ? onDelete : null,
                tooltip: canWrite ? 'Delete Collection' : 'No write permission',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
