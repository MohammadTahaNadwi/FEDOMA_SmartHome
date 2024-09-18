import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:smarthome/views/pop_up_screens.dart';

class reportView extends StatefulWidget {
  final String reportName;

  const reportView({super.key, required this.reportName});

  @override
  State<reportView> createState() => _reportViewState();
}

class _reportViewState extends State<reportView> {
  late final rName = widget.reportName;
  var reportMonth = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
        title: Text("$rName Statistics"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Report Criteria"),
                        content: const Text(
                            "I want to see a report for the following month:"),
                        actions: [
                          DropdownMenu(
                            dropdownMenuEntries: const <DropdownMenuEntry<
                                String>>[
                              DropdownMenuEntry(value: "01", label: "January"),
                              DropdownMenuEntry(value: "02", label: "February"),
                              DropdownMenuEntry(value: "03", label: "March"),
                              DropdownMenuEntry(value: "04", label: "April"),
                              DropdownMenuEntry(value: "05", label: "May"),
                              DropdownMenuEntry(value: "06", label: "June"),
                              DropdownMenuEntry(value: "07", label: "July"),
                              DropdownMenuEntry(value: "08", label: "August"),
                              DropdownMenuEntry(
                                  value: "09", label: "September"),
                              DropdownMenuEntry(value: "10", label: "October"),
                              DropdownMenuEntry(value: "11", label: "November"),
                              DropdownMenuEntry(
                                  value: "12", label: "Decemeber"),
                            ],
                            enableFilter: true,
                            enableSearch: true,
                            onSelected: (value) {
                              reportMonth = value.toString();

                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"))
                        ],
                      );
                    });
              },
              child: const Text("Select a month to view report")),
          FutureBuilder(
              future: getData(rName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  Map<dynamic, dynamic> data = snapshot.data!;
                  String room = "";
                  String time = "";
                  String date = "";
                  if (data["Time"] != null && data["Date"] != null) {
                    if (data["Room"] != null) {
                      room = data["Room"] as String;
                    }
                    if (data["Time"] != null) {
                      time = data["Time"];
                    }
                    if (data["Date"] != null) {
                      date = data["Date"] as String;
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          rName == "Intrusions" && room != ""
                              ? Text("Room: $room")
                              : const Text(""),
                          Text("Time: $time"),
                          Text("Date: $date"),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text("No Data found"));
                  }
                } else {
                  return const Center(child: Text("Failed to retrieve data"));
                }
              }),
          FutureBuilder(
            future: analyzeData(),
            builder: (context, snapshot) {
              devtools.log("here tooo");
              if (snapshot.connectionState == ConnectionState.none) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                Map<int, double> barChartData = snapshot.data!;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: BarChart(
                      BarChartData(
                        titlesData: const FlTitlesData(
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: getBottomTiles))),
                        barGroups: [
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(toY: barChartData[0] ?? 0)
                          ]),
                          BarChartGroupData(x: 2, barRods: [
                            BarChartRodData(toY: barChartData[1] ?? 0)
                          ]),
                          BarChartGroupData(x: 3, barRods: [
                            BarChartRodData(toY: barChartData[2] ?? 0)
                          ]),
                          BarChartGroupData(x: 4, barRods: [
                            BarChartRodData(toY: barChartData[3] ?? 0)
                          ]),
                          BarChartGroupData(x: 5, barRods: [
                            BarChartRodData(toY: barChartData[4] ?? 0)
                          ]),
                          BarChartGroupData(x: 6, barRods: [
                            BarChartRodData(toY: barChartData[5] ?? 0)
                          ]),
                          BarChartGroupData(x: 7, barRods: [
                            BarChartRodData(toY: barChartData[6] ?? 0)
                          ]),
                          BarChartGroupData(x: 8, barRods: [
                            BarChartRodData(toY: barChartData[7] ?? 0)
                          ]),
                          BarChartGroupData(x: 9, barRods: [
                            BarChartRodData(toY: barChartData[8] ?? 0)
                          ]),
                          BarChartGroupData(x: 10, barRods: [
                            BarChartRodData(toY: barChartData[9] ?? 0)
                          ]),
                          BarChartGroupData(x: 11, barRods: [
                            BarChartRodData(toY: barChartData[10] ?? 0)
                          ]),
                          BarChartGroupData(x: 12, barRods: [
                            BarChartRodData(toY: barChartData[11] ?? 0)
                          ])
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }

  Future getData(rName) async {
    var dataName = FirebaseDatabase.instance.ref().child(rName);
    DataSnapshot snapshot = await dataName.get();
    Map<dynamic, dynamic> result = snapshot.value as Map<dynamic, dynamic>;
    devtools.log("here");
    return result;
  }

  Future analyzeData() async {
    Map data = await getData(rName);
    Map<int, double> count = {};
    Iterable dataa = data.values;
    int dateCounter = 0;
    // devtools.log(data.values.toString());
    // devtools.log(dataa.elementAt(0)["Time"].toString());
    // dataa.forEach((index) {
    //   if (index["Date"] != null &&
    //       index["Date"].toString().substring(3, 5) == reportMonth) {
    //     dateCounter++;
    //   }
    //   devtools.log(index["Date"].toString().substring(3, 5));
    // });

    // devtools.log(dateCounter.toString());
    for (int i = 0; i < 12; i++) {
      dateCounter = 0;
      for (var index in dataa) {
        if (index["Date"].toString().substring(3, 5) == "0$i") {
          dateCounter++;
        }
      }
      devtools.log(count[i].toString());
      count[i] = dateCounter as double;
    }
    return count;
  }
}

Widget getBottomTiles(double value, TitleMeta meta) {
  const style = TextStyle(
      color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13);
  Widget text;
  switch (value.toInt()) {
    case 1:
      text = const Text(
        'J',
        style: style,
      );
      break;
    case 2:
      text = const Text(
        'F',
        style: style,
      );
      break;
    case 3:
      text = const Text(
        'M',
        style: style,
      );
      break;
    case 4:
      text = const Text(
        'A',
        style: style,
      );
      break;
    case 5:
      text = const Text(
        'M',
        style: style,
      );
      break;
    case 6:
      text = const Text(
        'J',
        style: style,
      );
      break;
    case 7:
      text = const Text(
        'J',
        style: style,
      );
      break;
    case 8:
      text = const Text(
        'A',
        style: style,
      );
      break;
    case 9:
      text = const Text(
        'S',
        style: style,
      );
      break;
    case 10:
      text = const Text(
        'O',
        style: style,
      );
      break;
    case 11:
      text = const Text(
        'N',
        style: style,
      );
      break;
    case 12:
      text = const Text(
        'D',
        style: style,
      );
      break;
    default:
      text = const Text(
        '',
      );
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
