import 'dart:convert';
import 'package:brain_tumor_final/contact_info.dart';
import 'package:brain_tumor_final/home.dart';
import 'package:brain_tumor_final/report%20page.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

import 'dart:io';

import 'package:flutter/material.dart';

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


