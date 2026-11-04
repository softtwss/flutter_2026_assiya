import 'package:flutter/material.dart';

import 'main.dart';
import 'cart_badge.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key, required this.cart, required this.onAdd});

  final List<Book> cart;
  final void Function(Book) onAdd;

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          CartBadge(
            count: cart.length,
            total: cart.fold<int>(0, (sum, b) => sum + b.price),
          ),
        ],
      ),
      body: ListView(
        children: books.map((b) {
          debugPrint('row ${b.title}');

          final added = cart.contains(b);

          return ListTile(
            title: Text(b.title),
            subtitle: Text(b.author),
            trailing: added
                ? const Text('Added')
                : OutlinedButton(
                    onPressed: () => onAdd(b),
                    child: const Text('Add'),
                  ),
          );
        }).toList(),
      ),
    );
  }
}
