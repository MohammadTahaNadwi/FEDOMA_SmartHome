import 'dart:io';
import 'dart:developer' as devtools show log;

import 'package:firebase_database/firebase_database.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';
import 'package:smarthome/views/reportView.dart';
import 'package:smarthome/views/savePDF.dart';

class Simplepdfapi {
  Future<File> generateSimpleTextPdf(String rName) async {
    final pdf = Document();
    var dataName = FirebaseDatabase.instance.ref().child(rName);
    DataSnapshot snapshot = await dataName.get();
    Map<dynamic, dynamic> result = snapshot.value as Map<dynamic, dynamic>;
    Iterable lissst = result.values!;

    List<List<dynamic>> data = [];
    for (int i = 0; i < result.length; i++) {
      // data.add( TableRow(children: [Text(lissst.elementAt(i)["Date"]),Text(lissst.elementAt(i)["Time"])]));
      data.add([
        lissst.elementAt(i)["Date"], // Add Date
        lissst.elementAt(i)["Time"] // Add Time
      ]); // Add Time
    }
    final tableHeader2;
    if (result.keys.length < 3) {
      tableHeader2 = "Record number";
    } else {
      tableHeader2 = result.keys.elementAt(2).toString();
    }

    final headers = [
      tableHeader2,
      Text(result.keys.elementAt(0).toString()),
      Text(result.keys.elementAt(1).toString())
    ];

    // pdf.addPage(Page(
    //     build: (_) => Center(
    //             child: Table(children: [
    //           TableRow(children: [
    //             Column(children: [Text(tableHeader2)]),
    //             Column(children: [Text(result.keys.elementAt(0).toString())]),
    //             Column(children: [Text(result.keys.elementAt(1).toString())])
    //           ]),

    //         ]))));

    pdf.addPage(Page(
        build: (_) => Center(
            child: TableHelper.fromTextArray(headers: headers, data: data))));

    return Savepdf().savePdf(rName: rName, pdf: pdf);
  }
}
