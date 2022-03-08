import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:productapp/pages/show_product_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            inputEmail(),
            inputPassword(),
            formButton(),
          ],
        ),
      ),
    );
  }

  Container formButton() {
    double width = 130;
    double height = 45;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          loginButton(width, height),
          registerButton(width, height),
        ],
      ),
    );
  }

  SizedBox registerButton(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
        ),
        onPressed: () {},
        child: const Text('สมัครสมาชิก'),
      ),
    );
  }

  SizedBox loginButton(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // check valid email and password by using laravel api
              var json = jsonEncode({
                "email": _email.text,
                "password": _password.text,
              });

              // Define your http laravel API location
              var url = Uri.parse(
                  'https://laravel-bankend-cs-125.herokuapp.com/api/login');

              // Request by POST Method
              var response = await http.post(
                url,
                body: json,
                headers: {HttpHeaders.contentTypeHeader: 'application/json'},
              );

              print(response.body);

              if (response.statusCode == 200) {
                // Store user and token to local storage by using SharedPreference
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var userJson = jsonDecode(response.body)['user'];
                var tokenJson = jsonDecode(response.body)['token'];
                await prefs.setStringList('user', [
                  userJson['name'],
                  userJson['email'],
                  userJson['role'].toString(),
                ]);
                await prefs.setString('token', tokenJson);
                // Navigate to ShowProduct Page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShowProductPage(),
                    ));
              }
              // if no, show alert -- error text
            }
          },
          child: const Text('เข้าสู่ระบบ')),
    );
  }

  Container inputEmail() {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 8),
      child: TextFormField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Enter Your E-mail';
          }
          return null;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.blue,
          ),
          label: Text(
            'E-mail',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Container inputPassword() {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: TextFormField(
        controller: _password,
        obscureText: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Enter Password';
          }
          return null;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.blue,
          ),
          label: Text(
            'Password',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
