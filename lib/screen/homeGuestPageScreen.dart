import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mioxi_frontend/services/irServices.dart';
import 'package:mioxi_frontend/controllers/userController.dart';
import 'package:mioxi_frontend/others/themeController.dart';


class HomeGuestPageScreen extends StatefulWidget {
  @override
  _HomeGuestPageScreenState createState() => _HomeGuestPageScreenState();
}

class _HomeGuestPageScreenState extends State<HomeGuestPageScreen> {
  final IrService irService = IrService();
  List<SpO2Data> spo2Data = [];
  double? currentSpo2;
  DateTime? lastTimestamp;
  late TooltipBehavior _tooltipBehavior;
  late StreamSubscription _spo2Subscription;
  final UserController _userController = UserController();

bool _infoShown = false;



  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);

    currentSpo2 = irService.currentSpo2;
    spo2Data = List.from(irService.spo2Data);
    lastTimestamp = irService.lastTimestamp;

    _spo2Subscription = irService.spo2Stream.listen((_) {
      setState(() {
        currentSpo2 = irService.currentSpo2;
        lastTimestamp = irService.lastTimestamp;

        // Agregamos los nuevos datos a nuestra lista local
        spo2Data = List.from(irService.spo2Data);

        // Mantener solo las últimas 6 muestras
        if (spo2Data.length > 6) {
          spo2Data = spo2Data.sublist(spo2Data.length - 6);
        }
      });
    });

    irService.connect();

  // 📌 Mostrar popup al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_infoShown) {        // 👈 solo si no se mostró antes
      _showInfoDialog(context);
      _infoShown = true;      // 👈 marcar como mostrado
    }

    });

  }

  @override
  void dispose() {
    _spo2Subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final isLight = Theme.of(context).brightness == Brightness.light;

    // 🎨 Colores dinámicos
    final appBarColor =
        isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final buttonColor =
        isLight ? const Color(0xFF0096C7) : const Color(0xFF003566);
    final altButtonBg =
        isLight ? const Color(0xFFCAF0F8) : const Color(0xFF001d3d);
    final graphColor =
        isLight ? const Color(0xFF0096C7) : const Color(0xFF90E0EF);
    final titleColor =
        isLight ? const Color(0xFF0096C7) : const Color(0xFF90E0EF);
    final textColor = isLight ? Colors.black87 : Colors.white;
    final lastRegsColor = isLight ? Color(0xFF00B4D8) : const Color.fromARGB(255, 154, 148, 148);


    String formattedTime =
        lastTimestamp != null
            ? DateFormat('HH:mm:ss').format(lastTimestamp!)
            : '--:--:--';

    return Scaffold(
      appBar: AppBar(
        title: const Text('MiOxi'),
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
          leadingWidth: 120, // 👈 espacio extra para dos botones
         leading:Row(
          mainAxisSize: MainAxisSize.min,
          children: [ IconButton(
          icon: Icon(
            isLight ? Icons.dark_mode : Icons.light_mode,
            color: Colors.white,
          ),
          onPressed: () => Get.find<ThemeController>().toggleTheme(),
        ),
                        const SizedBox(width: 8), // 👈 separación entre los botones
 IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              tooltip: 'Información',
              onPressed: () => _showInfoDialog(context),
            ),
          ],
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 19,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,
             color: Color(0xFFe2fdff),),
           
            tooltip: 'Cerrar sesión',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            currentSpo2 != null
                ? '${currentSpo2!.toStringAsFixed(1)} %'
                : '---',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: graphColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Último registro: $formattedTime',
            style: TextStyle(fontSize: 16, color: lastRegsColor),
          ),
          const SizedBox(height: 20),

          Expanded(
            //height: 540, // 🔽 Ajusta el alto como quieras (ej: 200, 250, 300)
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SfCartesianChart(
                title: ChartTitle(
                  text: '% SpO₂ en tiempo real\n',
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0096C7),
                  ),
                ),

                plotAreaBorderColor: const Color(0xFF0096C7).withOpacity(0),
                plotAreaBorderWidth: 1,
                tooltipBehavior: _tooltipBehavior,
                primaryXAxis: NumericAxis(
                  isVisible: false,
                  /*interval:
                      (spo2Data.isNotEmpty)
                          ? (spo2Data.last.time / 6)
                              .ceilToDouble() // fuerza 6 marcas
                          : 1,
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    return ChartAxisLabel('', TextStyle()); // ❌ sin etiquetas
                  },
                  
                  majorTickLines: const MajorTickLines(
                    width: 1.5, // grosor de la rayita
                    size: 6, // tamaño de la rayita
                    color: Color(0xFF0096C7), // color de la rayita
                  ),
                  majorGridLines: const MajorGridLines(
                    width: 0,
                  ), // ❌ sin líneas verticales*/
                  title: const AxisTitle(text: 'Tiempo'),
                ),

                primaryYAxis: NumericAxis(
                  minimum: 80,
                  maximum: 100,
                  labelFormat: '{value}%',
                  majorGridLines: MajorGridLines(
                    width: 2.5,
                    color: const Color(0xFF0096C7).withOpacity(0.2),
                  ),
                  //title: const AxisTitle(text: 'SpO₂'),
                ),
                series: <CartesianSeries<SpO2Data, double>>[
                  SplineAreaSeries<SpO2Data, double>(
                    dataSource: spo2Data,
                    xValueMapper: (SpO2Data data, _) => data.time,
                    yValueMapper: (SpO2Data data, _) => data.value,
                    name: 'SpO₂',
                    color: Colors.blue.withOpacity(0.3),
                    borderColor: Colors.blue,
                    borderWidth: 2,
                    splineType: SplineType.natural,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
void _showInfoDialog(BuildContext context) {
  final isLight = Theme.of(context).brightness == Brightness.light;
  final textColor = isLight ? Colors.black87 : Colors.white;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Información sobre las mediciones",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            color: textColor
          ),
        ),
        content: Text(
          "Las mediciones de oxígeno en sangre (%SpO₂) se realizan automáticamente aproximadamente cada 10 segundos.\n\n"
          "Para garantizar resultados confiables, la aplicación calcula el valor final a partir de un promedio de las últimas 5 mediciones consecutivas.\n\n"
          "Esto significa que el resultado definitivo puede tardar aproximadamente un minuto en mostrarse.\n\n"
          "Mientras tanto, podrá visualizar en la gráfica los valores intermedios en tiempo real.",
          style: TextStyle(
            fontSize: 16,
            color: textColor, // ✅ color interno
            fontFamily: 'OpenSans',
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Entendido"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}



  void _showLogoutDialog(BuildContext context) {
     final isLight = Theme.of(context).brightness == Brightness.light;

        final textColor = isLight ? Colors.black87 : Colors.white;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Text(
            "¿Estás segura de que quieres cerrar sesión?",
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontFamily: 'OpenSans',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE4E1)),
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
                _userController.logout();
                _infoShown= false;
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB31B1B)),
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
        );
      },
    );
  }
}