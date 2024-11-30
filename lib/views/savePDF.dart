import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as PDF;
import 'dart:developer' as devtools show log;

class Savepdf {
  Future<File> savePdf(
      {required String rName, required PDF.Document pdf}) async {
    final root = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    DateTime timestamp = DateTime.timestamp();
    String name = "$rName-$timestamp";
    final file = File('${root!.path}/$name.pdf');
    await file.writeAsBytes(await pdf.save());
    devtools.log('${root.path}/$name');
    return file;
  }

  Future<void> openFile(File file) async {
    final path = file.path;
    await OpenFile.open(path);
  }
}
