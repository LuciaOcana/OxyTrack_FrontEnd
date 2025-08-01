import 'package:flutter/material.dart';

class PaginatedListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final int currentPage;

  const PaginatedListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No hay elementos disponibles'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return itemBuilder(items[index]);
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onPreviousPage,
                child: const Text('Anterior'),
              ),
              const SizedBox(width: 16),
              Text('Página $currentPage'),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: onNextPage,
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
