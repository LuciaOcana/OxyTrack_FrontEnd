import 'package:flutter/material.dart';
import 'package:oxytrack_frontend/models/userDoctor.dart'; // Asegúrate de que esta ruta sea correcta

class DoctorCard extends StatelessWidget {
  final UserDoctorModel doctor;

  const DoctorCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Text(
          '${doctor.name} ${doctor.lastname}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('@${doctor.username}'),
        trailing: const Icon(Icons.info_outline, color: Colors.blueAccent),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Información de ${doctor.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${doctor.name} ${doctor.lastname}'),
                  const SizedBox(height: 8),
                  Text('Username: @${doctor.username}'),
                  const SizedBox(height: 8),
                  Text('Email: ${doctor.email}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
