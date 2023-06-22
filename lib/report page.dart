import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

import 'dart:io';

import 'package:share/share.dart';

class ReportPage extends StatelessWidget {
  static File? savedImage;
  final File? imageFile;
  final String name;
  final String contactName;
  final int contactAge;
  final String contactGender;
  final bool? contactHadTumor;
  final String contactConditionDescription;

  ReportPage({
    required this.imageFile,
    required this.name,
    required this.contactName,
    required this.contactAge,
    required this.contactGender,
    required this.contactHadTumor,
    required this.contactConditionDescription,
  });

  Future<Uint8List> _loadImage() async {
    if (savedImage != null) {
      return await savedImage!.readAsBytes();
    }
    return Uint8List(0);
  }

  void _shareReport() async {
    final Uint8List imageData = await _loadImage();
    final MemoryImage image = MemoryImage(imageData);

    // Generate the report as a string
    String report = '''
    Doctor Name: $name
    Patient Name: $contactName
    Patient Age: $contactAge
    Patient Gender: $contactGender
    Patient Had Tumor Before: ${contactHadTumor == true ? 'Yes' : 'No'}
    Patient Condition Description: $contactConditionDescription
  ''';

    // Create a PDF document
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text(report, style: pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 16),
                pw.Image(pw.MemoryImage(imageData), width: 200, height: 200),
              ],
            ),
          );
        },
      ),
    );

    // Convert the PDF document to bytes
    final pdfBytes = await pdf.save();

    // Get the temporary directory path
    final directory = await getTemporaryDirectory();
    final filePath = path.join(directory.path, 'report.pdf');

    // Save the PDF file
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    // Share the PDF file using the platform share method
    await Share.shareFiles(
      [filePath],
      text: 'Report',
      subject: 'Report PDF',
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2856C0),
        title: Text('Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareReport,
          ),
          //  IconButton(
          //   icon: Icon(Icons.open_in_browser),
          // onPressed: _launchURL,
          //   ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor Name: $name',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Patient Name: $contactName',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Patient Age: $contactAge',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Patient Gender: $contactGender',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Patient Had Tumor Before: ${contactHadTumor == true ? 'Yes' : 'No'}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Patient Condition Description: $contactConditionDescription',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'MRI :',
              style: TextStyle(fontSize: 18.0),
            ),
            FutureBuilder<Uint8List>(
              future: _loadImage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    height: 200,
                    width: 200,
                  );
                } else {
                  return Image.asset(
                    'assets/images/capture.png',
                    height: 200,
                    width: 200,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
