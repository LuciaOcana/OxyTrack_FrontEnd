import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:oxytrack_frontend/screen/logInScreen.dart';
import 'package:oxytrack_frontend/screen/logInDoctorScreen.dart';



class SelectorModeScreen extends StatelessWidget {
  const SelectorModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed('/loginAdmin');
            },
            child: const Text(
              'Administrador',
              style: TextStyle(color: Color(0xFF0077B6)),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                     // Spacer(flex: 1),   // Espacio arriba

                const SizedBox(height: 100),
                Image.asset(
                  'lib/others/images/SpO.png',
                  height: 300,
                ),

                const SizedBox(height: 10),  // <- Añadido espacio extra aquí

                Text(
                  'Bienvenido a Oxytrack',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00B4D8),
                  ),
                  textAlign: TextAlign.center,
                ),
                      //Spacer(flex: 1),   // espacio entre texto y botones

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/logIn');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF0096C7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Soy paciente',
                      style: TextStyle(
                        fontSize: 19,
                      color: Color(0xFFCAF0F8),
                      fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold),
                      ),
                    
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/loginDoctor');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF0077B6)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Soy personal médico',
                      style: TextStyle(fontSize: 18, color: Color(0xFF0077B6),
                      fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                      Spacer(flex: 2),  // espacio abajo para balancear

              ],
            ),
          ),
        ),
      ),
    );
  }
}