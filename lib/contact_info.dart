

import 'package:flutter/material.dart';

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
