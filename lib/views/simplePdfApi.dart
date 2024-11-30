import 'dart:io';
import 'dart:developer' as devtools show log;

import 'package:firebase_database/firebase_database.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:smarthome/views/savePDF.dart';

class Simplepdfapi {
  Future<File> generateSimpleTextPdf(String rName, String value) async {
    final pdf = pw.Document();
    final dbRef = FirebaseDatabase.instance.ref().child(rName);
    DataSnapshot snapshot = await dbRef.get();

    // Fetch data
    Map<dynamic, dynamic> result = snapshot.value as Map<dynamic, dynamic>;
    Iterable recordList = result.values;

    // Define headers dynamically
    final String tableHeader2 =
        (recordList.elementAt(0).length < 3) ? "Record Number" : "Room";
    final headers = [tableHeader2, "Date", "Time"];
    List<List<dynamic>> data = [];

    int recordNumbers = 1;
    for (int i = 0; i < result.length; i++) {
      if (recordList.elementAt(i)["Date"].toString().substring(3, 5) == value) {
        if (tableHeader2 == "Record Number") {
          data.add([
            recordNumbers,
            recordList.elementAt(i)["Date"],
            recordList.elementAt(i)["Time"]
          ]);
          recordNumbers++;
        } else {
          data.add([
            recordList.elementAt(i)["Room"],
            recordList.elementAt(i)["Date"],
            recordList.elementAt(i)["Time"]
          ]);
        }
      }
    }

    // Styles
    final titleStyle =
        pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold);
    final headerStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
    );
    final dataStyle = pw.TextStyle(fontSize: 10);

    // Add Title and Table to PDF
    pdf.addPage(pw.MultiPage(
      build: (context) => [
        // Title Section
        pw.Center(
          child: pw.Text("$rName Report", style: titleStyle),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          "Monthly Report for ${_getMonthName(value)}",
          style: pw.TextStyle(fontSize: 14),
        ),
        pw.Divider(),
        // Table Section
        pw.Table.fromTextArray(
          headers: headers,
          data: data,
          headerStyle: headerStyle,
          headerDecoration: pw.BoxDecoration(),
          cellStyle: dataStyle,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.center,
            2: pw.Alignment.center
          },
        ),
      ],
    ));

    return Savepdf().savePdf(rName: rName, pdf: pdf);
  }

  String _getMonthName(String monthValue) {
    const monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return monthNames[int.parse(monthValue) - 1];
  }
}
