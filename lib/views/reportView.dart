import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as PDF;
import 'package:smarthome/views/simplePdfApi.dart';

class ReportView extends StatefulWidget {
  final String reportName;
  const ReportView({super.key, required this.reportName});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  late final String rName = widget.reportName;
  String? selectedMonth; // Nullable variable for month selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
        title: Text("$rName Statistics"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Bar Chart Section
              const Text(
                "Monthly Statistics Overview",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                future: getData(rName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text("Error loading data. Please try again."));
                  } else if (snapshot.hasData) {
                    Map data = snapshot.data!;
                    Map<int, double> barChartData = processDataForChart(data);

                    return Container(
                      height: 300,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: BarChart(
                        BarChartData(
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: getBottomTiles,
                              ),
                            ),
                          ),
                          barGroups: generateBarChartGroups(barChartData),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                        child: Text("No data available for display."));
                  }
                },
              ),

              // Detailed Report Section
              const Divider(),
              const Text(
                "Detailed Report",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                margin: const EdgeInsets.all(8),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "If you want to view a detailed report, select a month below:",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        hint: const Text("Select a month"),
                        items: const [
                          DropdownMenuItem(value: "01", child: Text("January")),
                          DropdownMenuItem(
                              value: "02", child: Text("February")),
                          DropdownMenuItem(value: "03", child: Text("March")),
                          DropdownMenuItem(value: "04", child: Text("April")),
                          DropdownMenuItem(value: "05", child: Text("May")),
                          DropdownMenuItem(value: "06", child: Text("June")),
                          DropdownMenuItem(value: "07", child: Text("July")),
                          DropdownMenuItem(value: "08", child: Text("August")),
                          DropdownMenuItem(
                              value: "09", child: Text("September")),
                          DropdownMenuItem(value: "10", child: Text("October")),
                          DropdownMenuItem(
                              value: "11", child: Text("November")),
                          DropdownMenuItem(
                              value: "12", child: Text("December")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedMonth = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? "Please select a month" : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedMonth == null) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Error"),
                                content: const Text(
                                    "Please select a month before generating the report."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            final pdfFile = await Simplepdfapi()
                                .generateSimpleTextPdf(rName, selectedMonth!);
                            openFile(pdfFile);
                          }
                        },
                        child: const Text("Generate Report"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<dynamic, dynamic>> getData(String rName) async {
    try {
      final ref = FirebaseDatabase.instance.ref().child(rName);
      final snapshot = await ref.get();
      if (snapshot.exists && snapshot.value is Map) {
        return snapshot.value as Map<dynamic, dynamic>;
      } else {
        throw Exception("No valid data found.");
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      return {};
    }
  }

  Future<void> openFile(File file) async {
    final path = file.path;
    await OpenFile.open(path);
  }

  Map<int, double> processDataForChart(Map data) {
    Map<int, double> barChartData = {};
    Iterable dataValues = data.values;

    for (int i = 1; i <= 12; i++) {
      double count = 0;
      for (var record in dataValues) {
        if (record["Date"].toString().substring(3, 5) ==
            i.toString().padLeft(2, '0')) {
          count++;
        }
      }
      barChartData[i] = count;
    }
    return barChartData;
  }

  List<BarChartGroupData> generateBarChartGroups(
      Map<int, double> barChartData) {
    return List.generate(12, (index) {
      int month = index + 1;
      return BarChartGroupData(
        x: month,
        barRods: [BarChartRodData(toY: barChartData[month] ?? 0)],
      );
    });
  }
}

Widget getBottomTiles(double value, TitleMeta meta) {
  const style = TextStyle(
      color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13);
  final months = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"];
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(months[value.toInt() - 1], style: style),
  );
}
