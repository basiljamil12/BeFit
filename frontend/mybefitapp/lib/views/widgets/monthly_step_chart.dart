import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/steps_service.dart';

class MonthChart extends StatefulWidget {
  const MonthChart({Key? key}) : super(key: key);

  @override
  State<MonthChart> createState() => _MonthChartState();
}

class _MonthChartState extends State<MonthChart> {
  List<dynamic> dataList = [];
  late Future<dynamic> _stepData;
  String email = AuthService.firebase().currentUser?.email.toString() ?? '';

  @override
  void initState() {
    super.initState();
    //call step service here to get all steps
    _stepData = StepsClient().getAllStepData(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Monthly Steps'),
      ),
      backgroundColor: const Color.fromARGB(255, 104, 23, 50),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 400.0,
            maxWidth: 600.0,
          ),
          padding: const EdgeInsets.all(24.0),
          child: FutureBuilder(
              future: _stepData,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final model = snapshot.data!;
                  List<dynamic> stepList = StepsClient().parseJsonToList(model);
                  //WEEK
                  List<dynamic> filteredList = StepsClient().filterStepsByMonth(
                      stepList,
                      DateTime.now().month.toInt(),
                      DateTime.now().year.toInt());
                  List<dynamic> steps =
                      filteredList.map((item) => item["steps"]).toList();
                  dataList = steps;
                  return Chart(
                    layers: layers(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12.0).copyWith(
                      bottom: 12.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              })),
        ),
      ),
    );
  }

  List<ChartLayer> layers() {
    return [
      ChartAxisLayer(
        settings: ChartAxisSettings(
          x: ChartAxisSettingsAxis(
            frequency: 5.0,
            max: 30.0,
            min: 0.0,
            textStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
          y: ChartAxisSettingsAxis(
            frequency: 100.0,
            max: dataList
                .reduce((currentMax, element) =>
                    currentMax is num && element is num
                        ? (currentMax > element ? currentMax : element)
                        : currentMax)
                .toDouble(),
            min: 0.0,
            textStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10.0,
            ),
          ),
        ),
        labelX: (value) => (value + 1).toString(),
        labelY: (value) => value.toInt().toString(),
      ),
      ChartBarLayer(
        items: List.generate(
          dataList.length,
          (index) => ChartBarDataItem(
            color: const Color.fromARGB(255, 248, 225, 225),
            value: dataList[index] is num ? dataList[index].toDouble() : 0.0,
            x: index.toDouble(),
          ),
        ),
        settings: const ChartBarSettings(
          thickness: 8.0,
          radius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    ];
  }
}
