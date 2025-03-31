import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:oxytrack_frontend/models/user.dart';  // Importa el modelo de usuario
import 'package:oxytrack_frontend/services/userServices.dart';  // Importa los servicios

class homePageScreen extends StatefulWidget {
  @override
  _homePageScreen createState() => _homePageScreen();


}

class _homePageScreen extends State<homePageScreen>{

  @override
  Widget build(BuildContext context) { 
     return Scaffold(
      appBar: AppBar(
        title: Text('Medidor de Oxígeno'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        //child: OxygenLevelGauge(oxygenLevel: 95),
      ),
    );
  }
}