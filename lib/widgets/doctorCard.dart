import 'package:flutter/material.dart';
import '../models/userDoctor.dart'; // Ajusta la ruta si el teu model està en una altra carpeta

class DoctorCard extends StatelessWidget {
  final UserDoctorModel doctor;
  final VoidCallback? onEdit; // Callback para manejar la acción del botón

  const DoctorCard({Key? key, required this.doctor, this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Username: ${doctor.email}'),
            const SizedBox(height: 8),
            Text('Name: ${doctor.username}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Alinea a la derecha
              children: [
                ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
