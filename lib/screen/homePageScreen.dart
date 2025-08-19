import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:oxytrack_frontend/services/irServices.dart'; 
import 'package:oxytrack_frontend/controllers/userController.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final IrService irService = IrService();
  List<SpO2Data> spo2Data = [];
  double? currentSpo2;
  DateTime? lastTimestamp;
  late TooltipBehavior _tooltipBehavior;
  late StreamSubscription _spo2Subscription;
  final UserController _userController = UserController();

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
  }

  @override
  void dispose() {
    _spo2Subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = lastTimestamp != null
        ? DateFormat('HH:mm:ss').format(lastTimestamp!)
        : '--:--:--';

    return Scaffold(
      appBar: AppBar(
        title: const Text('OxyTrack'),
        backgroundColor: const Color(0xFF0096C7),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          fontSize: 19,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            currentSpo2 != null
                ? '${currentSpo2!.toStringAsFixed(1)} %'
                : '---',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0096C7),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Último registro: $formattedTime',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          const Text(
            'SpO₂ Actual',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SfCartesianChart(
                title: ChartTitle(
                  text: 'SpO₂ en tiempo real',
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                plotAreaBorderColor: const Color(0xFF0096C7).withOpacity(0),
                plotAreaBorderWidth: 1,
                tooltipBehavior: _tooltipBehavior,
                primaryXAxis: NumericAxis(
                  isVisible: false, // ocultar eje X
                ),
                primaryYAxis: NumericAxis(
                  minimum: 80,
                  maximum: 100,
                  labelFormat: '{value}%',
                  majorGridLines: MajorGridLines(
                    width: 2.5,
                    color: const Color(0xFF0096C7).withOpacity(0.2),
                  ),
                  title: const AxisTitle(text: 'SpO₂'),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: const Text(
          "¿Estás segura de que quieres cerrar sesión?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB31B1B),
            ),
            onPressed: () {
              _userController.logout();
            },
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );
  }
}
