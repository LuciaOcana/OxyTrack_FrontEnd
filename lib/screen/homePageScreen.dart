import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class homePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<homePageScreen> {
  List<_SpO2Data> spo2Data = [];
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);

    // Simular datos iniciales (20 muestras)
    spo2Data = List.generate(
      20,
      (index) => _SpO2Data(index.toDouble(), 95 + (index % 6).toDouble()),
    );

    // Simular nuevas muestras cada 5 segundos
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        if (spo2Data.length >= 20) {
          spo2Data.removeAt(0); // mantener tamaño máximo 20 puntos
        }
        // Genera un valor SpO2 aleatorio entre 90 y 100
        double newValue = 90 + (10 * (new DateTime.now().second % 6) / 5);
        spo2Data.add(_SpO2Data(spo2Data.length.toDouble(), newValue));
      });
      return true; // Sigue ejecutando indefinidamente
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medidor de Oxígeno'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          title: ChartTitle(text: 'SpO₂ en tiempo real (simulado)'),
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
          series: <CartesianSeries<dynamic, dynamic>>[
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
    );
  }
}

class _SpO2Data {
  _SpO2Data(this.time, this.value);
  final double time;
  final double value;
}
