import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:brain_tumor_final/contact_info.dart';
import 'package:brain_tumor_final/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
//import 'package:printing/printing.dart';
import 'package:path/path.dart' as path;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';

class ReportPage extends StatelessWidget {
  Future<Uint8List> generatePdf() async {
    // Create a PDF document
    final pdf = pw.Document();

    // Add a page to the document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello, World!'),
          );
        },
      ),
    );

    // Generate the PDF document as bytes
    return await pdf.save();
  }

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
  File? get _imageFile => imageFile;

  /*//void _printReport() async {
    // Generate the report as a string
    //String report = '''
    //Patient Name: $name
    //Contact Name: $contactName
    //Contact Age: $contactAge
    //Contact Gender: $contactGender
    //Contact Had Tumor Before: ${contactHadTumor == true ? 'Yes' : 'No'}
    //Contact Condition Description: $contactConditionDescription
    //MRI :$savedImage
  //''';

    //try {
      // Create a PDF document
      //final pdf = pw.Document();

      // Add a page to the document
     // pdf.addPage(
       // pw.Page(
         // build: (pw.Context context) {
           // return pw.Center(
             // child: pw.Text(report),
            //);
          //},
        //),
      //);

      // Print the document
      //await Printing.layoutPdf(
        //onLayout: (PdfPageFormat format) async => pdf.save(),
      //);

      //print('Report printed successfully.');
    //} catch (e) {
      //print('Failed to print report: $e');
    //}
  //}

   */
  void _shareReport() async {
    // Generate the report as a string
    String report = '''
    Doctor Name: $name
    patient Name: $contactName
    patient Age: $contactAge
    patient Gender: $contactGender
    patient Had Tumor Before: ${contactHadTumor == true ? 'Yes' : 'No'}
    patient Condition Description: $contactConditionDescription
  ''';

    // Create a PDF document
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(report),
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

  void _launchURL() async {
    // Generate the report as a string
    String report = '''
      Doctor Name: $name
      patient Name: $contactName
      patient Age: $contactAge
      patient Gender: $contactGender
      patient Had Tumor Before: ${contactHadTumor == true ? 'Yes' : 'No'}
      patient Condition Description: $contactConditionDescription
    ''';

    // Generate a data URI with the report
    final uri =
        'data:text/plain;charset=utf-8;base64,' + base64Encode(report.codeUnits);

    // Launch the URL using the url_launcher plugin
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch URL: $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2856C0),
        title: Text('Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: (){

            },
          ),
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
              'patient Name: $contactName',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'patient Age: $contactAge',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'patient Gender: $contactGender',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'patient Had Tumor Before: ${contactHadTumor == true ? 'Yes' : 'No'}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'patient Condition Description: $contactConditionDescription',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Text('MRI :',
              style: TextStyle(fontSize: 18.0),
            ),
            savedImage != null
                ? Image.file(
              savedImage!,
              height: 200,
              width: 200,
            )
                : Image.asset(
              'assets/images/capture.png',
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
