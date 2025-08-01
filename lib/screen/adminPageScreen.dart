import 'package:flutter/material.dart';
//import 'package:oxytrack_frontend/widgets/userCard.dart'; // Importa el modelo de usuario
import 'package:oxytrack_frontend/controllers/userAdminController.dart';
import 'package:oxytrack_frontend/models/userDoctor.dart';


class AdminPageScreen extends StatefulWidget {
  const AdminPageScreen({super.key});

  @override
  State<AdminPageScreen> createState() => _AdminPageScreenState();
}

class _AdminPageScreenState extends State<AdminPageScreen> {
 final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
    final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

    final UserAdminController _userAdminController= UserAdminController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Doctores'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Registro de doctores
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Registrar Doctor',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _userAdminController.usernameDoctorController,
                    decoration: const InputDecoration(labelText: 'username'),
                    validator: (value) =>
                        value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  TextFormField(
                    controller: _userAdminController.emailDoctorController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  TextFormField(
                    controller: _userAdminController.nameDoctorController,
                    decoration: const InputDecoration(labelText: 'name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  TextFormField(
                    controller: _userAdminController.lastnameDoctorController,
                    decoration: const InputDecoration(labelText: 'lastname'),
                    validator: (value) =>
                        value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  TextFormField(
                    controller: _userAdminController.passwordDoctorController,
                    decoration: const InputDecoration(labelText: 'password'),
                    validator: (value) =>
                        value!.isEmpty ? 'Este campo es obligatorio' : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: (){
                       _userAdminController.signUp();
                    
                    //style: ElevatedButton.styleFrom(
                      //backgroundColor: Colors.blueAccent,
                      //padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  },
                    child: const Text('Registrar', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            const Divider(),

            // Lista de doctores
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Doctores registrados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
           /* Column(
              children: _doctors
                  .map((doc) => DoctorCard(
                        name: doc['name'] ?? '',
                        username: doc['username'] ?? '',
                        email: doc['email'] ?? '',
                        specialty: doc['specialty'] ?? '',
                      ))
                  .toList(),
            ),*/
          ],
        ),
      ),
    );
  }
}
