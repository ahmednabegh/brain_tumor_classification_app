import 'dart:convert';
import 'package:brain_tumor_final/contact_info.dart';
import 'package:brain_tumor_final/home.dart';
import 'package:brain_tumor_final/report%20page.dart';
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
/*  // Widget _buildImageSelectionPage() {
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
*/
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


