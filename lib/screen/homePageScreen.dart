import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'package:oxytrack_frontend/services/irServices.dart'; // Importa los servicios

class homePageScreen extends StatefulWidget {
  @override
  _homePageScreenState createState() => _homePageScreenState();
}

class _homePageScreenState extends State<homePageScreen> {
  final IrService irService = IrService(); // misma instancia singleton
  List<_SpO2Data> spo2Data = [];
  double? currentSpo2;
  late TooltipBehavior _tooltipBehavior;
  late StreamSubscription _spo2Subscription;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);

    // Inicializar con los datos que ya existen en IrService
    currentSpo2 = irService.currentSpo2;
    spo2Data = List.from(irService.spo2Data);

    // Suscripción al stream para recibir datos nuevos
    _spo2Subscription = irService.spo2Stream.listen((data) {
      setState(() {
        currentSpo2 = irService.currentSpo2;
        spo2Data = List.from(irService.spo2Data);
      });
    });

    // Conectamos al WebSocket
    irService.connect();
  }

  @override
  void dispose() {
    _spo2Subscription.cancel();
    //irService.disconnect(); // solo desconecta el socket; stream permanece activo
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido a OxyTrack'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            currentSpo2 != null
                ? '${currentSpo2!.toStringAsFixed(1)} %'
                : '---',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'SpO₂ Actual',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SfCartesianChart(
                title: ChartTitle(text: 'Evolución de SpO₂'),
                tooltipBehavior: _tooltipBehavior,
                primaryXAxis: NumericAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  title: AxisTitle(text: 'Tiempo'),
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 80,
                  maximum: 100,
                  labelFormat: '{value}%',
                  axisLine: AxisLine(width: 0),
                  title: AxisTitle(text: 'SpO₂'),
                ),
                series: <CartesianSeries<_SpO2Data, double>>[
                  SplineAreaSeries<_SpO2Data, double>(
                    dataSource: spo2Data,
                    xValueMapper: (_SpO2Data data, _) => data.time,
                    yValueMapper: (_SpO2Data data, _) => data.value,
                    name: 'SpO₂',
                    color: Colors.blue.withOpacity(0.5),
                    borderColor: Colors.blue,
                    borderWidth: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpO2Data {
  _SpO2Data(this.time, this.value);
  final double time;
  final double value;
}
