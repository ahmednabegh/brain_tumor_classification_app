import 'dart:convert';
import 'package:brain_tumor_final/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:path/path.dart' as path;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  static const String routName = 'home';

  final String name;

  HomePage({required this.name});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;

  int _selectedIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      ContactInfoPage(onSaveData: _saveContactInfoData),
      Home(name:  widget.name),
      ReportPage(
        imageFile: _imageFile,
        name: widget.name,
        contactName: '',
        contactAge: 0,
        contactGender: '',
        contactHadTumor: null,
        contactConditionDescription: '',
      ),
    ];
  }
  // Widget _buildImageSelectionPage() {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Image Selection'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //             'Hi, ${widget.name}! Please select an MRI photo.',
  //             style: TextStyle(color: Colors.black, fontSize: 24.0),
  //           ),
  //           SizedBox(height: 16.0),
  //           _imageFile != null
  //               ? Image.file(
  //             _imageFile!,
  //             height: 200,
  //             width: 200,
  //           )
  //               : Image.asset(
  //             'assets/images/capture.png',
  //             height: 200,
  //             width: 200,
  //           ),
  //           SizedBox(height: 16.0),
  //           ElevatedButton(
  //             onPressed: _selectImageFromGallery,
  //             child: Text('Select Image from Gallery'),
  //           ),
  //           SizedBox(height: 8.0),
  //           ElevatedButton(
  //             onPressed: _selectImageFromCamera,
  //             child: Text('Take Photo'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // Future<void> _selectImageFromGallery() async {
  //   final imagePicker = ImagePicker();
  //   final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
  //
  //   if (pickedImage != null) {
  //     setState(() {
  //       _imageFile = File(pickedImage.path);
  //     });
  //   }
  // }
  //
  // Future<void> _selectImageFromCamera() async {
  //   final imagePicker = ImagePicker();
  //   final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
  //
  //   if (pickedImage != null) {
  //     setState(() {
  //       _imageFile = File(pickedImage.path);
  //     });
  //   }
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _saveContactInfoData(String name, int age, String gender, bool? hadTumor,
      String conditionDescription) {
    setState(() {
      _pages[2] = ReportPage(
        name: widget.name,
        contactName: name,
        contactAge: age,
        contactGender: gender,
        contactHadTumor: hadTumor,
        contactConditionDescription: conditionDescription,
        imageFile: _imageFile,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Patient Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Image Selection',
          ),
          BottomNavigationBarItem(

            icon: Icon(Icons.receipt),
            label: 'Report',
          ),
        ],
      ),
    );
  }
}

class ContactInfoPage extends StatefulWidget {
  final Function(String, int, String, bool?, String) onSaveData;

  ContactInfoPage({required this.onSaveData});

  @override
  _ContactInfoPageState createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  String? _name;
  int? _age;
  String? _gender;
  bool? _hadTumor;
  String? _conditionDescription;
  List<String> _genderOptions = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: AppBar(
          
          backgroundColor: Colors.transparent,
          title: Text('Patient Info'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/Doctor.png'),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name'),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text('Age'),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _age = int.tryParse(value);
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text('Gender'),
                  DropdownButton<String>(
                    value: _gender,
                    items: _genderOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text('Had Tumor Before'),
                  DropdownButton<bool>(
                    value: _hadTumor,
                    items: [
                      DropdownMenuItem<bool>(
                        value: true,
                        child: Text('Yes'),
                      ),
                      DropdownMenuItem<bool>(
                        value: false,
                        child: Text('No'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _hadTumor = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text('Condition Description'),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _conditionDescription = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Save the contact info data
                      // You can perform any necessary data validation and storage here
                      widget.onSaveData(
                        _name ?? '',
                        _age ?? 0,
                        _gender ?? '',
                        _hadTumor,
                        _conditionDescription ?? '',
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Patient info data saved.'),
                        ),
                      );
                    },
                    child: Text('Save Data'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  File? get _imageFile => imageFile;

  void _printReport() async {
    // Generate the report as a string
    String report = '''
    Patient Name: $name
    Contact Name: $contactName
    Contact Age: $contactAge
    Contact Gender: $contactGender
    Contact Had Tumor Before: ${contactHadTumor == true ? 'Yes' : 'No'}
    Contact Condition Description: $contactConditionDescription
    MRI :$savedImage
  ''';

    try {
      // Create a PDF document
      final pdf = pw.Document();

      // Add a page to the document
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(report),
            );
          },
        ),
      );

      // Print the document
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      print('Report printed successfully.');
    } catch (e) {
      print('Failed to print report: $e');
    }
  }
  void _shareReport() {
    // Generate the report as a string
    String report = '''
      Doctor Name: $name
      patient Name: $contactName
      patient Age: $contactAge
      patient Gender: $contactGender
      patient Had Tumor Before: ${contactHadTumor == true ? 'Yes' : 'No'}
      patient Condition Description: $contactConditionDescription
      MRI  :$savedImage
    ''';

    // Share the report using the share plugin
    Share.share(report);
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
            onPressed: _printReport,
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
