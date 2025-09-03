import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mioxi_frontend/controllers/userAdminController.dart';
import 'package:mioxi_frontend/controllers/doctorListController.dart';
import 'package:mioxi_frontend/others/themeController.dart';

class AdminAddDoctorPageScreen extends StatefulWidget {
  const AdminAddDoctorPageScreen({super.key});

  @override
  State<AdminAddDoctorPageScreen> createState() =>
      _AdminAddDoctorPageScreenState();
}

class _AdminAddDoctorPageScreenState extends State<AdminAddDoctorPageScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserAdminController _userAdminController = Get.put(UserAdminController());
  final DoctorListController _doctorListController = Get.put(DoctorListController());

  @override
  void initState() {
    super.initState();
    _userAdminController.loadPatients(); // Carga pacientes al iniciar
  }

  InputDecoration _inputDecoration(String label, bool isLight) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: isLight ? Colors.grey[100] : Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final appBarColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final buttonColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final titleColor = isLight ? const Color(0xFF0096C7) : const Color(0xFF90E0EF);
    final textColor = isLight ? Colors.black87 : Colors.white;
    final dialogBg = isLight ? Colors.white : const Color(0xFF1E1E1E);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión del personal'),
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(isLight ? Icons.dark_mode : Icons.light_mode, color: Colors.white),
          onPressed: () => Get.find<ThemeController>().toggleTheme(),
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFe2fdff)),
            tooltip: 'Cerrar sesión',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Registrar doctor',
                    style: TextStyle(
                      fontSize: 24,
                      color: titleColor,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Campos de formulario
                  ..._buildFormFields(isLight),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _registerDoctor,
                    child: const Text(
                      'Registrar',
                      style: TextStyle(
                        fontSize: 19,
                        color: Color(0xFFCAF0F8),
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields(bool isLight) {
    final textColor = isLight ? Colors.black87 : Colors.white;
    final dialogBg = isLight ? Colors.white : const Color(0xFF1E1E1E);

    return [
      TextFormField(
        controller: _userAdminController.usernameDoctorController,
        decoration: _inputDecoration('Nombre de usuario', isLight),
        validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _userAdminController.emailDoctorController,
        decoration: _inputDecoration('Correo electrónico', isLight),
        validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _userAdminController.nameDoctorController,
        decoration: _inputDecoration('Nombre', isLight),
        validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _userAdminController.lastnameDoctorController,
        decoration: _inputDecoration('Apellido', isLight),
        validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
      ),
      const SizedBox(height: 12),
      _buildPatientSelector(isLight, textColor, dialogBg),
      const SizedBox(height: 12),
      TextFormField(
        controller: _userAdminController.passwordDoctorController,
        decoration: _inputDecoration('Contraseña', isLight),
        obscureText: true,
        validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
      ),
    ];
  }

  Widget _buildPatientSelector(bool isLight, Color textColor, Color dialogBg) {
    return Obx(() {
      return InkWell(
        onTap: () async {
          final results = await showDialog<List<String>>(
            context: context,
            builder: (context) {
              List<String> tempSelected = List.from(_userAdminController.selectedPatients);
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    backgroundColor: dialogBg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text('Seleccionar pacientes', style: TextStyle(color: textColor)),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView(
                        children: _userAdminController.patientsList.map((patient) {
                          return CheckboxListTile(
                            title: Text(patient),
                            value: tempSelected.contains(patient),
                            onChanged: (selected) {
                              setState(() {
                                if (selected == true) {
                                  tempSelected.add(patient);
                                } else {
                                  tempSelected.remove(patient);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, null),
                        child: Text('Cancelar', style: TextStyle(color: textColor)),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, tempSelected),
                        child: Text('Aceptar', style: TextStyle(color: textColor)),
                      ),
                    ],
                  );
                },
              );
            },
          );
          if (results != null) {
            _userAdminController.selectedPatients.value = results;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: isLight ? Colors.grey[100] : Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isLight ? Colors.black12 : Colors.black54,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            _userAdminController.selectedPatients.isEmpty
                ? 'Seleccionar pacientes'
                : _userAdminController.selectedPatients.join(', '),
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ),
      );
    });
  }

  void _registerDoctor() async {
    if (_formKey.currentState!.validate()) {
      final success = await _userAdminController.signUp();
      if (success) {
        _userAdminController.usernameDoctorController.clear();
        _userAdminController.emailDoctorController.clear();
        _userAdminController.nameDoctorController.clear();
        _userAdminController.lastnameDoctorController.clear();
        _userAdminController.passwordDoctorController.clear();
        _userAdminController.selectedPatients.clear();

        Get.snackbar(
          'Éxito',
          'Doctor registrado correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        _doctorListController.fetchDoctors();
        _userAdminController.loadPatients();
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? Colors.black87 : Colors.white;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          "¿Estás seguro de que quieres cerrar sesión?",
          style: TextStyle(fontSize: 16, color: textColor, fontFamily: 'OpenSans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFE4E1)),
            child: const Text(
              "Cancelar",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFB31B1B),
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _userAdminController.logout();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB31B1B)),
            child: const Text(
              "Cerrar sesión",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFFFE4E1),
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
