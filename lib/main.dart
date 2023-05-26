import 'package:brain_tumor_final/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brain_tumor_final/login.dart';
import 'package:brain_tumor_final/register.dart';


void main(){
  runApp(MyApp());


}
class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes:{
        LoginPage.routName:(context)=>LoginPage(),

        RegistrationPage.routName:(context)=>RegistrationPage(),
        HomePage.routName:(context)=>HomePage(name: ''),

              },
      initialRoute: LoginPage.routName,
    );
  }
}