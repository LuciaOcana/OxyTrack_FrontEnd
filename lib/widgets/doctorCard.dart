import 'package:flutter/material.dart';
import '../models/userDoctor.dart'; // Ajusta la ruta si el teu model està en una altra carpeta

class DoctorCard extends StatelessWidget {
  final UserDoctorModel doctor;

  const DoctorCard({Key? key, required this.doctor}) : super(key: key);

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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Username: ${doctor.email}'),
            const SizedBox(height: 8),
            Text('Name: ${doctor.username}'),
          ],
        ),
      ),
    );
  }
}
