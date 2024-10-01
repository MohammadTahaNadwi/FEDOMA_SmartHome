import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as PDF;

import 'dart:developer' as devtools show log;

import 'package:smarthome/views/pop_up_screens.dart';
import 'package:smarthome/views/simplePdfApi.dart';

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
                            onSelected: (value) async {
                              reportMonth = value.toString();
                              final simplePDFFile = await Simplepdfapi()
                                  .generateSimpleTextPdf(
                                      rName, value.toString());
                              openFile(simplePDFFile);
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
            future: getData(rName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                Map data = snapshot.data!;
                Map<int, double> barChartData = {};
                Iterable dataa = data.values;
                double dateCounter = 0;
                Map answer = dataa.elementAt(0) as Map;
                for (int i = 1; i < 13; i++) {
                  dateCounter = 0;
                  for (int j = 0; j < dataa.length; j++) {
                    answer = dataa.elementAt(j);
                    if (answer["Date"].toString().substring(3, 5) == "0$i" ||
                        answer["Date"].toString().substring(3, 5) ==
                            i.toString()) {
                      dateCounter++;
                    }
                  }
                  barChartData[i] = dateCounter;
                }

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
                            BarChartRodData(toY: barChartData[1] ?? 0)
                          ]),
                          BarChartGroupData(x: 2, barRods: [
                            BarChartRodData(toY: barChartData[2] ?? 0)
                          ]),
                          BarChartGroupData(x: 3, barRods: [
                            BarChartRodData(toY: barChartData[3] ?? 0)
                          ]),
                          BarChartGroupData(x: 4, barRods: [
                            BarChartRodData(toY: barChartData[4] ?? 0)
                          ]),
                          BarChartGroupData(x: 5, barRods: [
                            BarChartRodData(toY: barChartData[5] ?? 0)
                          ]),
                          BarChartGroupData(x: 6, barRods: [
                            BarChartRodData(toY: barChartData[6] ?? 0)
                          ]),
                          BarChartGroupData(x: 7, barRods: [
                            BarChartRodData(toY: barChartData[7] ?? 0)
                          ]),
                          BarChartGroupData(x: 8, barRods: [
                            BarChartRodData(toY: barChartData[8] ?? 0)
                          ]),
                          BarChartGroupData(x: 9, barRods: [
                            BarChartRodData(toY: barChartData[9] ?? 0)
                          ]),
                          BarChartGroupData(x: 10, barRods: [
                            BarChartRodData(toY: barChartData[10] ?? 0)
                          ]),
                          BarChartGroupData(x: 11, barRods: [
                            BarChartRodData(toY: barChartData[11] ?? 0)
                          ]),
                          BarChartGroupData(x: 12, barRods: [
                            BarChartRodData(toY: barChartData[12] ?? 0)
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
          ),
          FutureBuilder(
              future: getData(rName),
              builder: (context, snapshot) {
                Map answer = {};
                if (snapshot.connectionState == ConnectionState.none) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  Iterable data = snapshot.data!.values;
                  final tableHeader2;
                  if (answer.keys.length < 3) {
                    tableHeader2 = "Record number";
                  } else {
                    tableHeader2 = answer.keys.elementAt(2).toString();
                  }

                  for (int len = 0; len < data.length; len++) {
                    answer = data.elementAt(len);
                    if (reportMonth != "") {
                      if (answer["Date"].toString().substring(3, 5) ==
                          reportMonth) {
                        devtools.log(answer.toString());
                        devtools.log(answer.values.elementAt(0).toString());
                        devtools.log(answer.length.toString());
                      }
                    }
                  }

                  return Table(
                    border: TableBorder.all(color: Colors.black),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.green),
                          children: [
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(tableHeader2)),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child:
                                    Text(answer.keys.elementAt(0).toString())),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text(
                                    answer.values.elementAt(1).toString())),
                          ]),
                    ],
                  );
                } else {
                  return Text("No Data Found");
                }
              }),
        ],
      ),
    );
  }

  Future<Map<dynamic, dynamic>> getData(rName) async {
    var dataName = FirebaseDatabase.instance.ref().child(rName);
    DataSnapshot snapshot = await dataName.get();
    Map<dynamic, dynamic> result = snapshot.value as Map<dynamic, dynamic>;
    return result;
  }

  Future<File> savePdf(
      {required String name, required PDF.Document pdf}) async {
    final root = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    DateTime timestamp = DateTime.timestamp();
    String name = "$rName-$timestamp";
    final file = File('${root!.path}/$name');
    await file.writeAsBytes(await pdf.save());
    debugPrint('${root.path}/$name');
    return file;
  }

  Future<void> openFile(File file) async {
    final path = file.path;
    await OpenFile.open(path);
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
