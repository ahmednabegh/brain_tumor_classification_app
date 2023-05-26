import 'package:brain_tumor_final/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  final String name;

  Home({required this.name});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  File? _imageFile;

  Future<void> _selectImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Future<void> _saveImageAndNavigateToReportPage() async {
    if (_imageFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(_imageFile!.path);
      final savedImage = await _imageFile!.copy('${appDir.path}/$fileName');

      ReportPage.savedImage = savedImage; // Assign the saved image to the static variable

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Image Saved'),
            content: Text('The image has been saved.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No Image Selected'),
            content: Text('Please select an image first.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(

      children:[

        Image.asset('assets/images/home_background.png',

          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,

        ),


        Scaffold(
          backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,

          title: Text('MRI tab'),
        ),
        body:

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hi, ${widget.name}! Please select an MRI photo.',
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 16.0),
              _imageFile != null
                  ? Image.file(
                _imageFile!,
                height: 200,
                width: 200,
              )
                  : Image.asset(
                'assets/images/capture.png',
                height: 200,
                width: 200,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _selectImageFromGallery,
                child: Text('Select Image from Gallery'),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _selectImageFromCamera,
                child: Text('Take Photo'),
              ),
              ElevatedButton(onPressed: (){},
                  child: Text('Classify')),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _saveImageAndNavigateToReportPage,
                child: Text('Save Image and Go to Report'),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
