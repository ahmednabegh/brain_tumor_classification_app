import 'package:brain_tumor_final/home_page.dart';
import 'package:brain_tumor_final/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import the Brain Cancer page

class LoginPage extends StatefulWidget {
  static const String routName = 'login';


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedEmail = prefs.getString('email') ?? '';
    String savedPassword = prefs.getString('password') ?? '';
String savedName = prefs.getString('name')??'';
    if (emailController.text == savedEmail && passwordController.text == savedPassword) {
      // Navigate to the Brain Cancer page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(name: savedName),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/login_background.png',

width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,

        ),

        Scaffold(
          backgroundColor: Colors.transparent,
        appBar: AppBar(
       backgroundColor: Colors.transparent,

          title: Text('Login'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',

                  labelStyle:

                  TextStyle(
                      fontSize: 30,
                      color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white),
              ),

              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      fontSize: 30,
                      color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white),
              ),

              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  await _login(context);
                },
                child: Text('Login'),
              ),
              SizedBox(height: 12.0),
              TextButton(
                onPressed: () {
                  // Navigate to the Registration page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationPage(),
                    ),
                  );
                },
                child: Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),]
    );
  }
}
