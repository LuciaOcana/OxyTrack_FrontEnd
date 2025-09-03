// ======================================================
// paginatedListView.dart
// Widget genérico para mostrar listas paginadas
// Incluye navegación entre páginas con botones
// ======================================================

import 'package:flutter/material.dart';

class PaginatedListView<T> extends StatelessWidget {
  /// Lista de elementos a mostrar
  final List<T> items;

  /// Función que construye el widget para cada elemento
  final Widget Function(T item) itemBuilder;

  /// Callback para ir a la siguiente página
  final VoidCallback onNextPage;

  /// Callback para ir a la página anterior
  final VoidCallback onPreviousPage;

  /// Página actual (para mostrar en la UI)
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
        // 🔹 Lista de elementos
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No hay elementos disponibles'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => itemBuilder(items[index]),
                ),
        ),

        // 🔹 Paginación
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón "Anterior"
              ElevatedButton(
                onPressed: onPreviousPage,
                child: const Text('Anterior'),
              ),
              const SizedBox(width: 16),

              // Página actual
              Text('Página $currentPage'),

              const SizedBox(width: 16),

              // Botón "Siguiente"
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
