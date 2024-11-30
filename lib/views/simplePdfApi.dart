import 'dart:io';
import 'dart:developer' as devtools show log;

import 'package:firebase_database/firebase_database.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';
import 'package:smarthome/views/reportView.dart';
import 'package:smarthome/views/savePDF.dart';

class Simplepdfapi {
  Future<File> generateSimpleTextPdf(String rName, String value) async {
    final pdf = Document();
    var dataName = FirebaseDatabase.instance.ref().child(rName);
    DataSnapshot snapshot = await dataName.get();
    Map<dynamic, dynamic> result = snapshot.value as Map<dynamic, dynamic>;
    Iterable lissst = result.values;

    List<List<dynamic>> data = [];
    final String tableHeader2;
    if (lissst.elementAt(0).length < 3) {
      tableHeader2 = "Record number";
    } else {
      tableHeader2 = "Room";
    }
    int recordNumbers = 1;
    for (int i = 0; i < result.length; i++) {
      if (lissst.elementAt(i)["Date"].toString().substring(3, 5) == value) {
        if (tableHeader2 == "Record number") {
          data.add([
            recordNumbers,
            lissst.elementAt(i)["Date"], // Add Date
            lissst.elementAt(i)["Time"] // Add Time
          ]);
          recordNumbers++;
        } else {
          data.add([
            lissst.elementAt(i)["Room"],
            lissst.elementAt(i)["Date"], // Add Date
            lissst.elementAt(i)["Time"] // Add Time
          ]); // Add Time
        }
      }
    }

    final headers = [tableHeader2, "Date", "Time"];

    pdf.addPage(Page(
        build: (_) => Center(
            child: TableHelper.fromTextArray(headers: headers, data: data))));

    return Savepdf().savePdf(rName: rName, pdf: pdf);
  }
}
